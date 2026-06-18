import SwiftUI

struct CellBuilderGameView: View {
    @State private var cellType: GameContent.CellType = .animal
    @State private var placed: [String: String] = [:]
    @State private var draggingID: String?
    @State private var dragOffset: CGSize = .zero
    @State private var diagramFrame: CGRect = .zero
    @State private var completed = false
    @State private var wrongDrop = false

    private var organelles: [GameContent.Organelle] {
        GameContent.organelles(for: cellType)
    }

    private var zones: [GameContent.CellZone] {
        GameContent.zones(for: cellType)
    }

    private var unplaced: [GameContent.Organelle] {
        organelles.filter { placed[$0.id] == nil }
    }

    var body: some View {
        MiniGameShell(
            title: "Cell Builder",
            accent: Subject.biology.gameColor,
            correct: placed.count,
            missed: wrongDrop ? 1 : 0,
            showScore: true
        ) {
            VStack(spacing: 16) {
                Picker("Cell type", selection: $cellType) {
                    ForEach(GameContent.CellType.allCases) { type in
                        Text(type.title).tag(type)
                    }
                }
                .pickerStyle(.segmented)
                .onChange(of: cellType) { _, _ in resetBoard() }

                Text("Drag each organelle to its zone")
                    .font(GameFont.caption())
                    .foregroundStyle(GameColors.textSecondary)

                cellDiagram
                    .frame(maxWidth: 400, maxHeight: 360)
                    .background(
                        GeometryReader { proxy in
                            Color.clear
                                .onAppear { diagramFrame = proxy.frame(in: .global) }
                                .onChange(of: proxy.frame(in: .global)) { _, frame in
                                    diagramFrame = frame
                                }
                        }
                    )

                organelleTray

                if wrongDrop {
                    Text("Try a different zone!")
                        .font(GameFont.caption())
                        .foregroundStyle(GameColors.incorrect)
                }

                if completed {
                    Text("Cell complete! 🌿")
                        .font(GameFont.headline())
                        .foregroundStyle(GameColors.correct)
                    Button("Play again") { resetBoard() }
                        .buttonStyle(.borderedProminent)
                }
            }
        }
    }

    private var cellDiagram: some View {
        GeometryReader { geo in
            let size = geo.size
            ZStack {
                cellOutline(in: size)
                ForEach(zones) { zone in
                    zoneView(zone, in: size)
                }
                ForEach(organelles.filter { placed[$0.id] != nil }) { organelle in
                    if let zone = zones.first(where: { $0.id == organelle.zoneID }) {
                        placedChip(organelle, zone: zone, in: size)
                    }
                }
            }
        }
        .aspectRatio(1.1, contentMode: .fit)
        .gameCard(color: GameColors.cardSurface2, padding: 8)
    }

    private func cellOutline(in size: CGSize) -> some View {
        Group {
            if cellType == .plant {
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .stroke(GameColors.biology.opacity(0.6), lineWidth: 4)
                    .padding(4)
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(GameColors.biology.opacity(0.35), lineWidth: 2)
                    .padding(16)
            } else {
                Circle()
                    .stroke(GameColors.biology.opacity(0.5), lineWidth: 3)
                    .padding(12)
            }
        }
        .frame(width: size.width, height: size.height)
    }

    private func zoneView(_ zone: GameContent.CellZone, in size: CGSize) -> some View {
        let center = CGPoint(x: zone.centerX * size.width, y: zone.centerY * size.height)
        let diameter = zone.radius * min(size.width, size.height) * 2
        let occupied = placed.values.contains(zone.id)
        return ZStack {
            Circle()
                .stroke(
                    occupied ? GameColors.correct.opacity(0.5) : GameColors.textTertiary.opacity(0.4),
                    style: StrokeStyle(lineWidth: 2, dash: occupied ? [] : [5, 4])
                )
                .frame(width: diameter, height: diameter)
            Text(zone.label)
                .font(.system(size: 9, weight: .medium, design: .rounded))
                .foregroundStyle(GameColors.textTertiary)
                .multilineTextAlignment(.center)
                .frame(width: diameter)
        }
        .position(center)
    }

    private func placedChip(_ organelle: GameContent.Organelle, zone: GameContent.CellZone, in size: CGSize) -> some View {
        let center = CGPoint(x: zone.centerX * size.width, y: zone.centerY * size.height)
        return Label(organelle.name, systemImage: organelle.icon)
            .font(.system(size: 10, weight: .semibold, design: .rounded))
            .padding(.horizontal, 8)
            .padding(.vertical, 6)
            .background(GameColors.correct.opacity(0.25))
            .foregroundStyle(GameColors.textPrimary)
            .clipShape(Capsule())
            .position(center)
    }

    private var organelleTray: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(unplaced) { organelle in
                    organelleChip(organelle)
                }
            }
            .padding(.horizontal, 4)
        }
        .frame(height: 56)
    }

    private func organelleChip(_ organelle: GameContent.Organelle) -> some View {
        let isDragging = draggingID == organelle.id
        return Label(organelle.name, systemImage: organelle.icon)
            .font(GameFont.caption(.semibold))
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .background(GameColors.cardSurface)
            .foregroundStyle(GameColors.textPrimary)
            .clipShape(Capsule())
            .overlay(Capsule().stroke(GameColors.biology.opacity(0.4), lineWidth: 1))
            .offset(isDragging ? dragOffset : .zero)
            .scaleEffect(isDragging ? 1.05 : 1)
            .zIndex(isDragging ? 1 : 0)
            .gesture(
                DragGesture(coordinateSpace: .global)
                    .onChanged { value in
                        draggingID = organelle.id
                        dragOffset = value.translation
                    }
                    .onEnded { value in
                        handleDrop(organelle: organelle, at: value.location)
                        draggingID = nil
                        dragOffset = .zero
                    }
            )
    }

    private func handleDrop(organelle: GameContent.Organelle, at globalPoint: CGPoint) {
        guard diagramFrame.width > 0 else {
            wrongDrop = true
            return
        }
        let local = CGPoint(
            x: globalPoint.x - diagramFrame.minX,
            y: globalPoint.y - diagramFrame.minY
        )
        let size = diagramFrame.size

        if let zone = zones.first(where: { zone in
            let center = CGPoint(x: zone.centerX * size.width, y: zone.centerY * size.height)
            let radius = zone.radius * min(size.width, size.height)
            let dx = local.x - center.x
            let dy = local.y - center.y
            return sqrt(dx * dx + dy * dy) <= radius
        }) {
            if zone.id == organelle.zoneID {
                placed[organelle.id] = zone.id
                wrongDrop = false
                checkCompletion()
            } else {
                wrongDrop = true
            }
        } else {
            wrongDrop = true
        }
    }

    private func checkCompletion() {
        if placed.count == organelles.count {
            completed = true
            XPManager.shared.awardCustom(points: 25)
        }
    }

    private func resetBoard() {
        placed = [:]
        completed = false
        wrongDrop = false
        draggingID = nil
        dragOffset = .zero
    }
}
