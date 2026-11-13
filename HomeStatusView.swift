//
//  HomeStatusView.swift
//  SmartHome
//
//  A SwiftUI recreation of the "Home status / Favorite Actions" screen.
//  Target: iOS 16+
//

import SwiftUI

// MARK: - Models

struct FavoriteAction: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let icon: String
    let iconColor: Color
    let iconBackground: Color
    let trailingText: String?      // e.g. "40%" or "8kw/h"
    let trailingTextColor: Color

    init(title: String,
         subtitle: String,
         icon: String,
         iconColor: Color = .white,
         iconBackground: Color,
         trailingText: String? = nil,
         trailingTextColor: Color = .green) {
        self.title = title
        self.subtitle = subtitle
        self.icon = icon
        self.iconColor = iconColor
        self.iconBackground = iconBackground
        self.trailingText = trailingText
        self.trailingTextColor = trailingTextColor
    }
}

// MARK: - Color palette

extension Color {
    static let appBackground = Color(red: 0.06, green: 0.06, blue: 0.07)
    static let cardBackground = Color(red: 0.13, green: 0.13, blue: 0.14)
    static let cardBackgroundAlt = Color(red: 0.17, green: 0.17, blue: 0.18)
    static let mutedText = Color(white: 0.55)
    static let shutterOrange = Color(red: 0.94, green: 0.35, blue: 0.15)
    static let lightYellow = Color(red: 0.98, green: 0.71, blue: 0.13)
    static let batteryGreen = Color(red: 0.24, green: 0.72, blue: 0.32)
    static let nightBlue = Color(red: 0.15, green: 0.65, blue: 0.93)
}

// MARK: - Sample Data

let favoriteActions: [FavoriteAction] = [
    FavoriteAction(title: "Front station", subtitle: "Garage", icon: "battery.100",
                   iconBackground: .batteryGreen, trailingText: "40%", trailingTextColor: .batteryGreen),
    FavoriteAction(title: "Shutter", subtitle: "Kitchen", icon: "line.3.horizontal",
                   iconBackground: .shutterOrange),
    FavoriteAction(title: "West Shutter", subtitle: "Bedroom", icon: "line.3.horizontal",
                   iconBackground: .shutterOrange),
    FavoriteAction(title: "Electricity", subtitle: "Home", icon: "bolt.fill",
                   iconColor: .nightBlue, iconBackground: .white),
    FavoriteAction(title: "Light", subtitle: "Attic", icon: "lightbulb.fill",
                   iconColor: .white, iconBackground: .lightYellow),
    FavoriteAction(title: "Shutter", subtitle: "Balcony", icon: "line.3.horizontal",
                   iconBackground: .shutterOrange),
    FavoriteAction(title: "Shutter", subtitle: "Children's", icon: "line.3.horizontal",
                   iconBackground: .shutterOrange),
    FavoriteAction(title: "Light", subtitle: "Living Room", icon: "lightbulb.fill",
                   iconColor: .white, iconBackground: .lightYellow),
    FavoriteAction(title: "Solar Panel", subtitle: "Home", icon: "square.grid.2x2.fill",
                   iconColor: .nightBlue, iconBackground: .cardBackgroundAlt,
                   trailingText: "8kw/h", trailingTextColor: .nightBlue),
    FavoriteAction(title: "Light", subtitle: "Hallway", icon: "lightbulb.fill",
                   iconColor: .white, iconBackground: .white)
]

// MARK: - Main View

struct HomeStatusView: View {
    @State private var nightModeOn = true
    @State private var selectedTab = "Kitchen"

    private let tabs = ["Kitchen", "Living Room", "Bedroom"]
    private let columns = [
        GridItem(.flexible(), spacing: 14),
        GridItem(.flexible(), spacing: 14)
    ]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 28) {

                header

                VStack(alignment: .leading, spacing: 16) {
                    Text("Home status")
                        .font(.system(size: 26, weight: .bold))
                        .foregroundColor(.white)

                    nightModeCard
                }

                VStack(alignment: .leading, spacing: 18) {
                    HStack(spacing: 20) {
                        Text("Favorite Actions")
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(.white)

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 20) {
                                ForEach(tabs, id: \.self) { tab in
                                    Text(tab)
                                        .font(.system(size: 17, weight: .semibold))
                                        .foregroundColor(tab == selectedTab ? .white : .mutedText)
                                        .onTapGesture { selectedTab = tab }
                                }
                            }
                        }
                    }

                    LazyVGrid(columns: columns, spacing: 14) {
                        ForEach(favoriteActions) { action in
                            FavoriteActionCard(action: action)
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 12)
            .padding(.bottom, 32)
        }
        .background(Color.appBackground.ignoresSafeArea())
        .preferredColorScheme(.dark)
    }

    private var header: some View {
        HStack {
            ZStack(alignment: .topTrailing) {
                Image(systemName: "bell")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(.white)
                Circle()
                    .fill(Color.red)
                    .frame(width: 7, height: 7)
                    .offset(x: 4, y: -2)
            }
            Spacer()
            Image(systemName: "line.3.horizontal")
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(.white)
        }
    }

    private var nightModeCard: some View {
        HStack {
            ZStack {
                Circle()
                    .fill(Color.nightBlue)
                    .frame(width: 44, height: 44)
                Image(systemName: "moon.fill")
                    .font(.system(size: 18))
                    .foregroundColor(.white)
            }

            Text("Night mode")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.white)
                .padding(.leading, 10)

            Spacer()

            Image(systemName: "chevron.down")
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(.mutedText)
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 18)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color.cardBackground)
        )
    }
}

// MARK: - Favorite Action Card

struct FavoriteActionCard: View {
    let action: FavoriteAction

    var body: some View {
        VStack(alignment: .leading, spacing: 22) {
            VStack(alignment: .leading, spacing: 2) {
                Text(action.title)
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(.white)
                    .lineLimit(1)
                Text(action.subtitle)
                    .font(.system(size: 14))
                    .foregroundColor(.mutedText)
            }

            HStack {
                if let trailingText = action.trailingText {
                    Text(trailingText)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(action.trailingTextColor)
                }
                Spacer()
                ZStack {
                    Circle()
                        .fill(action.iconBackground)
                        .frame(width: 34, height: 34)
                    Image(systemName: action.icon)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(action.iconColor)
                }
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Color.cardBackground)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(Color.white.opacity(0.06), lineWidth: 1)
        )
    }
}

// MARK: - Preview

struct HomeStatusView_Previews: PreviewProvider {
    static var previews: some View {
        HomeStatusView()
    }
}
