import Foundation
import SwiftUI

enum AppLanguage: String, CaseIterable, Identifiable {
    case fr, en
    var id: String { rawValue }
    var displayCode: String { rawValue.uppercased() }
}

@MainActor
final class LanguageStore: ObservableObject {
    @AppStorage("app_lang") private var stored: String = ""
    @Published var current: AppLanguage = .fr

    init() {
        if let lang = AppLanguage(rawValue: stored), !stored.isEmpty {
            current = lang
        } else {
            let pref = (Locale.preferredLanguages.first ?? "fr").lowercased()
            current = pref.hasPrefix("en") ? .en : .fr
        }
    }

    func set(_ lang: AppLanguage) {
        current = lang
        stored = lang.rawValue
    }

    func t(_ key: String, _ params: [String: String] = [:]) -> String {
        var s = Strings.lookup(key: key, lang: current)
        for (k, v) in params {
            s = s.replacingOccurrences(of: "{\(k)}", with: v)
        }
        return s
    }
}

enum Strings {
    static func lookup(key: String, lang: AppLanguage) -> String {
        switch lang {
        case .fr: return fr[key] ?? key
        case .en: return en[key] ?? fr[key] ?? key
        }
    }

    static let fr: [String: String] = [
        "app_name": "Space Command",
        "tab_launches": "Lancements",
        "tab_ency": "Encyclopédie",
        "tab_alerts": "Alertes",
        "tab_settings": "Réglages",

        "h_kicker": "// mission control · temps réel",
        "h_title": "Prochains lancements",
        "h_sub": "Falcon 9, Falcon Heavy et Starship — comptes à rebours, patches de mission, statistiques de la flotte et l'historique de vie complet de chaque booster réutilisé.",

        "e_kicker": "// base de connaissances · specs & Wikipédia",
        "e_title": "Encyclopédie des lanceurs",
        "e_sub": "Les technologies de SpaceX en détail : caractéristiques techniques, performances et résumé encyclopédique mis à jour en direct depuis Wikipédia.",

        "search_ph": "Rechercher une mission, un orbite, un pad…",
        "next_launch": "▸ Prochain décollage",
        "date_tbd": "Date à confirmer",
        "cd_tbd": "À confirmer",
        "cd_inprogress": "EN COURS / RÉCENT",
        "cd_launched": "Lancé",
        "cd_days": "Jours", "cd_hours": "Heures", "cd_min": "Min", "cd_sec": "Sec",

        "stat_launches": "Lancements SpaceX", "stat_since": "depuis 2006",
        "stat_landings": "Atterrissages réussis", "stat_inrow": "{n} d'affilée",
        "stat_reuse": "Record réutilisation", "stat_reuse_sub": "Booster {s}",
        "stat_consec": "Vols réussis d'affilée", "stat_consec_sub": "Falcon 9",
        "stat_turn": "Record turnaround", "stat_turn_sub": "Temps minimum",
        "stat_upcoming": "Lancements à venir", "stat_upcoming_sub": "au programme",

        "tab_all": "Tous", "tab_other": "Autre",
        "flight_n": "vol #{n}", "reused": "réutilisé", "firstflight": "1er vol", "newvehicle": "Nouveau lanceur",
        "none_title": "Aucun lancement trouvé", "none_sub": "Essaie un autre filtre ou une autre recherche.",

        "m_mission": "Mission", "m_keyfacts": "Informations clés", "m_boosters": "Historique des lanceurs",
        "m_timeline": "Chronologie du vol", "m_links": "Suivre & en savoir plus", "m_wikicontext": "Contexte — Wikipédia",
        "if_rocket": "Fusée", "if_orbit": "Orbite visée", "if_mtype": "Type de mission", "if_pad": "Pad de tir",
        "if_site": "Site", "if_status": "Statut", "if_liftoff": "Décollage",
        "b_core": "Étage", "b_reused": "réutilisé", "b_firstflight": "premier vol",
        "b_total": "Vols totaux", "b_landings": "Atterrissages", "b_attempts": "Tentatives", "b_turn": "Turnaround",
        "b_firstdate": "Premier vol", "b_lastdate": "Dernier vol",
        "b_nodata": "Aucune donnée de booster publiée pour ce vol (lanceur neuf ou non communiqué).",

        "notify_on": "Me prévenir 1 h avant",
        "notify_set": "Notification programmée",
        "notify_cancel": "Annuler la notification",
        "notify_unavailable": "Notifications non autorisées",

        "ency_inservice": "En service",
        "ency_inservice_sub": "flotte active de SpaceX",
        "ency_boosters": "Boosters actifs",
        "ency_boosters_sub": "flotte Falcon 9 Block 5",
        "ency_crewdragon": "Crew Dragon",
        "ency_crewdragon_sub": "capsules habitées",
        "ency_cargodragon": "Cargo Dragon",
        "ency_cargodragon_sub": "capsules de fret vers l'ISS",
        "ency_retired": "Hors service",
        "ency_retired_sub": "lanceurs retirés & versions de développement",
        "b_flights": "VOLS",
        "b_land": "ATTERR.",
        "b_last_pad": "Dernier pad",
        "cd_missions": "MISSIONS",
        "cd_crew": "ÉQUIPAGE",
        "cd_status": "STATUT",
        "cd_first_flight": "Premier vol",
        "cd_last_flight": "Dernier vol",
        "cd_next_flight": "Prochain vol",
        "wiki_loading": "Résumé Wikipédia…",
        "wiki_read_on": "Lire sur Wikipédia",

        "err_title": "Données momentanément indisponibles",
        "err_body": "L'API publique (Launch Library 2) limite le nombre de requêtes par heure. Réessaie dans un instant.",
        "err_retry": "Réessayer",

        "settings_lang": "Langue",
        "settings_notif": "Notifications",
        "settings_about": "À propos",
        "settings_data": "Données : The Space Devs · Launch Library 2",
        "settings_summaries": "Résumés : Wikipédia (CC BY-SA)",
        "settings_disclaim": "Space Command — projet non officiel, sans affiliation avec SpaceX.",
        "settings_version": "Version",

        "alerts_empty": "Aucune alerte programmée",
        "alerts_empty_sub": "Active une alerte depuis l'écran d'une mission.",
        "alerts_title": "Alertes programmées",
        "alerts_kicker": "// alertes",

        "set_open_settings": "Ouvrir Réglages",
        "set_enable_notif": "Activer les notifications",
        "set_cancel_all": "Tout annuler ({n})",
        "set_notif_on": "Notifications activées",
        "set_notif_off": "Notifications refusées",
        "set_notif_prov": "Notifications discrètes",
        "set_notif_none": "Non configurées",

        "webcast": "Webcast",
        "no_launches_title": "Aucun lancement",
        "no_launches_sub": "Les données n'ont pas pu être chargées. Peux-tu réessayer ?",

        "support_title": "Soutenir",
        "support_sub": "ce projet indépendant",
        "support_btn": "Offrir un café ☕",
        "support_desc": "Space Command est gratuit et sans publicité. Si l'app t'est utile, tu peux soutenir son développement.",

        "dayunit": "j",

        "updated_at": "MAJ {t}",
        "offline_badge": "HORS-LIGNE"
    ]

    static let en: [String: String] = [
        "app_name": "Space Command",
        "tab_launches": "Launches",
        "tab_ency": "Encyclopedia",
        "tab_alerts": "Alerts",
        "tab_settings": "Settings",

        "h_kicker": "// mission control · real-time data",
        "h_title": "Upcoming launches",
        "h_sub": "Falcon 9, Falcon Heavy and Starship — countdowns, mission patches, fleet statistics and the full life history of every reused booster.",

        "e_kicker": "// knowledge base · specs & Wikipedia",
        "e_title": "Launch vehicle encyclopedia",
        "e_sub": "SpaceX's technologies in detail: technical characteristics, performance and an encyclopedic summary pulled live from Wikipedia.",

        "search_ph": "Search a mission, an orbit, a pad…",
        "next_launch": "▸ Next liftoff",
        "date_tbd": "Date TBD",
        "cd_tbd": "TBD",
        "cd_inprogress": "IN PROGRESS / RECENT",
        "cd_launched": "Launched",
        "cd_days": "Days", "cd_hours": "Hours", "cd_min": "Min", "cd_sec": "Sec",

        "stat_launches": "SpaceX launches", "stat_since": "since 2006",
        "stat_landings": "Successful landings", "stat_inrow": "{n} in a row",
        "stat_reuse": "Reuse record", "stat_reuse_sub": "Booster {s}",
        "stat_consec": "Consecutive successes", "stat_consec_sub": "Falcon 9",
        "stat_turn": "Turnaround record", "stat_turn_sub": "Minimum gap",
        "stat_upcoming": "Upcoming launches", "stat_upcoming_sub": "scheduled",

        "tab_all": "All", "tab_other": "Other",
        "flight_n": "flight #{n}", "reused": "reused", "firstflight": "1st flight", "newvehicle": "New vehicle",
        "none_title": "No launch found", "none_sub": "Try another filter or another search.",

        "m_mission": "Mission", "m_keyfacts": "Key facts", "m_boosters": "Launcher history",
        "m_timeline": "Flight timeline", "m_links": "Watch & learn more", "m_wikicontext": "Context — Wikipedia",
        "if_rocket": "Rocket", "if_orbit": "Target orbit", "if_mtype": "Mission type", "if_pad": "Launch pad",
        "if_site": "Site", "if_status": "Status", "if_liftoff": "Liftoff",
        "b_core": "Stage", "b_reused": "reused", "b_firstflight": "first flight",
        "b_total": "Total flights", "b_landings": "Landings", "b_attempts": "Attempts", "b_turn": "Turnaround",
        "b_firstdate": "First flight", "b_lastdate": "Last flight",
        "b_nodata": "No booster data published for this flight (new or undisclosed vehicle).",

        "notify_on": "Notify me 1 h before",
        "notify_set": "Notification scheduled",
        "notify_cancel": "Cancel notification",
        "notify_unavailable": "Notifications not allowed",

        "ency_inservice": "In service",
        "ency_inservice_sub": "SpaceX active fleet",
        "ency_boosters": "Active boosters",
        "ency_boosters_sub": "Falcon 9 Block 5 fleet",
        "ency_crewdragon": "Crew Dragon",
        "ency_crewdragon_sub": "crewed capsules",
        "ency_cargodragon": "Cargo Dragon",
        "ency_cargodragon_sub": "cargo capsules to the ISS",
        "ency_retired": "Retired",
        "ency_retired_sub": "retired vehicles & development versions",
        "b_flights": "FLIGHTS",
        "b_land": "LANDINGS",
        "b_last_pad": "Last pad",
        "cd_missions": "MISSIONS",
        "cd_crew": "CREW",
        "cd_status": "STATUS",
        "cd_first_flight": "First flight",
        "cd_last_flight": "Last flight",
        "cd_next_flight": "Next flight",
        "wiki_loading": "Wikipedia summary…",
        "wiki_read_on": "Read on Wikipedia",

        "err_title": "Data temporarily unavailable",
        "err_body": "The public API (Launch Library 2) limits the number of requests per hour. Please try again shortly.",
        "err_retry": "Retry",

        "settings_lang": "Language",
        "settings_notif": "Notifications",
        "settings_about": "About",
        "settings_data": "Data: The Space Devs · Launch Library 2",
        "settings_summaries": "Summaries: Wikipedia (CC BY-SA)",
        "settings_disclaim": "Space Command — unofficial project, not affiliated with SpaceX.",
        "settings_version": "Version",

        "alerts_empty": "No alerts scheduled",
        "alerts_empty_sub": "Enable an alert from a mission screen.",
        "alerts_title": "Scheduled alerts",
        "alerts_kicker": "// alerts",

        "set_open_settings": "Open Settings",
        "set_enable_notif": "Enable notifications",
        "set_cancel_all": "Cancel all ({n})",
        "set_notif_on": "Notifications enabled",
        "set_notif_off": "Notifications denied",
        "set_notif_prov": "Provisional notifications",
        "set_notif_none": "Not configured",

        "webcast": "Webcast",
        "no_launches_title": "No launches",
        "no_launches_sub": "Data couldn't be loaded. Try again?",

        "support_title": "Support",
        "support_sub": "this independent project",
        "support_btn": "Buy me a coffee ☕",
        "support_desc": "Space Command is free and ad-free. If you find it useful, you can support its development.",

        "dayunit": "d",

        "updated_at": "Updated {t}",
        "offline_badge": "OFFLINE"
    ]
}
