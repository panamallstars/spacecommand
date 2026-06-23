import SwiftUI

struct LaunchesView: View {
    @StateObject private var vm = LaunchesViewModel()
    @EnvironmentObject var lang: LanguageStore
    @State private var selected: Launch?

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 22) {
                    header
                    if case .loaded(let launches) = vm.state {
                        if launches.isEmpty {
                            VStack(spacing: 14) {
                                Image(systemName: "questionmark.circle")
                                    .font(.system(size: 36, weight: .light))
                                    .foregroundColor(Palette.muted)
                                Text(lang.t("no_launches_title"))
                                    .font(Font2.orbitron(16, weight: .semibold))
                                    .foregroundColor(Palette.text)
                                Text(lang.t("no_launches_sub"))
                                    .font(Font2.body(13))
                                    .foregroundColor(Palette.muted)
                                    .multilineTextAlignment(.center)
                                Button(action: { Task { await vm.load() } }) {
                                    Label(lang.t("err_retry"), systemImage: "arrow.clockwise")
                                        .font(Font2.body(14, weight: .semibold))
                                        .foregroundColor(.black)
                                        .padding(.horizontal, 18).padding(.vertical, 10)
                                        .background(AccentGradient.style)
                                        .clipShape(Capsule())
                                }
                                .buttonStyle(.plain)
                                .padding(.top, 6)
                            }
                            .padding(.vertical, 50)
                            .frame(maxWidth: .infinity)
                        } else {
                            if let next = vm.next {
                                NextLaunchHero(launch: next)
                                    .onTapGesture { selected = next }
                            }
                            StatStrip(launches: launches)
                            familyTabs(counts: vm.counts(), total: launches.count)
                            SearchField(text: $vm.query, placeholder: lang.t("search_ph"))
                            grid
                        }
                    } else if case .error = vm.state {
                        ErrorState { Task { await vm.load() } }
                    } else {
                        skeletons
                    }
                }
                .padding(.horizontal, 18)
                .padding(.top, 8)
                .padding(.bottom, 120)
            }
            .background(StarsBackground())
            .scrollContentBackground(.hidden)
            .refreshable { await vm.load() }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    BrandMark()
                }
            }
            .toolbarBackground(Palette.bg.opacity(0.85), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .task { if case .loading = vm.state { await vm.load() } }
            .sheet(item: $selected) { launch in
                MissionDetailView(launch: launch)
                    .environmentObject(lang)
            }
        }
        .tint(Palette.accent)
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(lang.t("h_kicker"))
                .font(Font2.mono(10, weight: .semibold))
                .tracking(2.8)
                .foregroundColor(Palette.accent)
            Text(lang.t("h_title"))
                .font(Font2.orbitron(34, weight: .heavy))
                .foregroundStyle(
                    LinearGradient(
                        colors: [.white, Color(red: 0.624, green: 0.851, blue: 1.0), Palette.accent2],
                        startPoint: .leading, endPoint: .trailing
                    )
                )
            Text(lang.t("h_sub"))
                .font(Font2.body(14))
                .foregroundColor(Palette.muted)
        }
        .padding(.top, 4)
    }

    private var grid: some View {
        let cols = [GridItem(.adaptive(minimum: 320), spacing: 16)]
        let items = vm.filtered()
        return LazyVGrid(columns: cols, spacing: 16) {
            ForEach(items) { launch in
                LaunchCard(launch: launch)
                    .environmentObject(lang)
                    .onTapGesture { selected = launch }
            }
            if items.isEmpty {
                EmptyResult()
                    .frame(maxWidth: .infinity)
            }
        }
    }

    private var skeletons: some View {
        let cols = [GridItem(.adaptive(minimum: 320), spacing: 16)]
        return LazyVGrid(columns: cols, spacing: 16) {
            ForEach(0..<6, id: \.self) { _ in
                Skeleton()
            }
        }
    }

    private func familyTabs(counts: [RocketFamily: Int], total: Int) -> some View {
        let items: [(label: String, family: RocketFamily?, count: Int, color: Color)] = [
            (lang.t("tab_all"), nil, total, Palette.text),
            ("Falcon 9", .falcon9, counts[.falcon9] ?? 0, Palette.f9),
            ("Falcon Heavy", .falconHeavy, counts[.falconHeavy] ?? 0, Palette.fh),
            ("Starship", .starship, counts[.starship] ?? 0, Palette.ss),
            (lang.t("tab_other"), .other, counts[.other] ?? 0, Palette.muted)
        ]
        return ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(items.indices, id: \.self) { i in
                    let it = items[i]
                    if it.family == nil || it.count > 0 {
                        Button {
                            vm.filter = it.family
                        } label: {
                            HStack(spacing: 8) {
                                Circle().fill(it.color).frame(width: 8, height: 8)
                                Text(it.label)
                                    .font(Font2.body(13, weight: .semibold))
                                Text("\(it.count)")
                                    .font(Font2.mono(10))
                                    .foregroundColor(Palette.faint)
                                    .padding(.horizontal, 6).padding(.vertical, 2)
                                    .background(Color.white.opacity(0.04))
                                    .clipShape(Capsule())
                            }
                            .foregroundColor(vm.filter == it.family ? Palette.text : Palette.muted)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 9)
                            .background(
                                Group {
                                    if vm.filter == it.family {
                                        LinearGradient(
                                            colors: [Palette.accent.opacity(0.18), Palette.accent2.opacity(0.18)],
                                            startPoint: .topLeading, endPoint: .bottomTrailing
                                        )
                                    } else {
                                        Color.clear
                                    }
                                }
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(vm.filter == it.family ? Palette.strokeStrong : Color.clear, lineWidth: 0.5)
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .padding(6)
        }
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Palette.panel.opacity(0.55))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Palette.stroke, lineWidth: 0.5)
        )
    }
}

struct BrandMark: View {
    var body: some View {
        HStack(spacing: 10) {
            Circle()
                .fill(Palette.accent)
                .frame(width: 9, height: 9)
                .shadow(color: Palette.accent.opacity(0.8), radius: 4)
            VStack(alignment: .leading, spacing: 0) {
                Text("SPACE COMMAND")
                    .font(Font2.orbitron(13, weight: .black))
                    .tracking(3)
                    .foregroundColor(Palette.text)
                Text("SpaceX launch tracker · live")
                    .font(Font2.body(9))
                    .foregroundColor(Palette.muted)
            }
        }
    }
}

struct LangToggle: View {
    @EnvironmentObject var lang: LanguageStore
    var body: some View {
        HStack(spacing: 2) {
            ForEach(AppLanguage.allCases) { l in
                Button {
                    lang.set(l)
                } label: {
                    Text(l.displayCode)
                        .font(Font2.mono(11, weight: .semibold))
                        .tracking(0.6)
                        .padding(.horizontal, 9).padding(.vertical, 5)
                        .background(
                            Group {
                                if lang.current == l {
                                    AccentGradient()
                                } else {
                                    Color.clear
                                }
                            }
                        )
                        .foregroundColor(lang.current == l ? Color.black : Palette.muted)
                        .clipShape(RoundedRectangle(cornerRadius: 7))
                }
                .buttonStyle(.plain)
            }
        }
        .padding(3)
        .background(Palette.panel.opacity(0.7))
        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Palette.stroke, lineWidth: 0.5))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

struct SearchField: View {
    @Binding var text: String
    let placeholder: String

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(Palette.muted)
            TextField("", text: $text, prompt: Text(placeholder).foregroundColor(Palette.faint))
                .textFieldStyle(.plain)
                .foregroundColor(Palette.text)
                .font(Font2.body(14))
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
            if !text.isEmpty {
                Button { text = "" } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(Palette.faint)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 11)
        .panel(radius: 13)
    }
}

struct Skeleton: View {
    @State private var phase: CGFloat = 0
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Rectangle().fill(shimmer).frame(height: 132)
            Rectangle().fill(shimmer).frame(height: 14).padding(.horizontal, 14)
            Rectangle().fill(shimmer).frame(height: 14).frame(width: 140).padding(.horizontal, 14)
            Spacer().frame(height: 14)
        }
        .panel(radius: 18)
        .frame(height: 240)
        .onAppear {
            withAnimation(.linear(duration: 1.4).repeatForever(autoreverses: false)) {
                phase = 1
            }
        }
    }

    private var shimmer: LinearGradient {
        LinearGradient(
            colors: [Palette.panelSolid, Palette.panel.opacity(1.4), Palette.panelSolid],
            startPoint: .leading, endPoint: .trailing
        )
    }
}

struct EmptyResult: View {
    @EnvironmentObject var lang: LanguageStore
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 32, weight: .light))
                .foregroundColor(Palette.muted)
            Text(lang.t("none_title"))
                .font(Font2.orbitron(16, weight: .semibold))
                .foregroundColor(Palette.text)
            Text(lang.t("none_sub"))
                .font(Font2.body(13))
                .foregroundColor(Palette.muted)
        }
        .padding(.vertical, 60)
    }
}

struct ErrorState: View {
    let retry: () -> Void
    @EnvironmentObject var lang: LanguageStore
    @State private var isRetrying = false

    var body: some View {
        VStack(spacing: 14) {
            Image(systemName: "antenna.radiowaves.left.and.right.slash")
                .font(.system(size: 36, weight: .light))
                .foregroundColor(Palette.hold)
            Text(lang.t("err_title"))
                .font(Font2.orbitron(16, weight: .semibold))
                .foregroundColor(Palette.text)
            Text(lang.t("err_body"))
                .font(Font2.body(13))
                .foregroundColor(Palette.muted)
                .multilineTextAlignment(.center)
            Button(action: {
                isRetrying = true
                retry()
                Task {
                    try? await Task.sleep(nanoseconds: 600_000_000)
                    isRetrying = false
                }
            }) {
                if isRetrying {
                    HStack(spacing: 8) {
                        ProgressView().tint(.black).scaleEffect(0.8)
                        Label(lang.t("err_retry"), systemImage: "arrow.clockwise")
                    }
                } else {
                    Label(lang.t("err_retry"), systemImage: "arrow.clockwise")
                }
            }
            .font(Font2.body(14, weight: .semibold))
            .foregroundColor(.black)
            .padding(.horizontal, 18).padding(.vertical, 10)
            .background(AccentGradient())
            .clipShape(Capsule())
            .buttonStyle(.plain)
            .disabled(isRetrying)
            .opacity(isRetrying ? 0.8 : 1)
            .padding(.top, 6)
        }
        .padding(.vertical, 50)
        .frame(maxWidth: .infinity)
    }
}
