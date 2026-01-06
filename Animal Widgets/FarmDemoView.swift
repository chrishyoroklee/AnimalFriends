//
//  FarmDemoView.swift
//  Animal Widgets
//
//  Created by Codex.
//

import SpriteKit
import SwiftUI

struct FarmDemoView: View {
    var scene: SKScene {
        let scene = FarmDemoScene()
        scene.scaleMode = .resizeFill
        scene.backgroundColor = AppTheme.uiBackground
        return scene
    }

    var body: some View {
        NavigationStack {
            SpriteView(scene: scene, options: [.allowsTransparency])
                .ignoresSafeArea()
                .navigationTitle("Farm Demo")
        }
    }
}

final class FarmDemoScene: SKScene {
    private let characterCount = 5
    private let moveDuration: TimeInterval = 4.0

    override func didMove(to view: SKView) {
        removeAllChildren()
        addBackground()
        addCharacters()
    }

    override func didChangeSize(_ oldSize: CGSize) {
        removeAllChildren()
        addBackground()
        addCharacters()
    }

    private func addBackground() {
        let ground = SKShapeNode(rectOf: CGSize(width: size.width, height: size.height))
        ground.fillColor = AppTheme.uiBackground
        ground.strokeColor = .clear
        ground.position = CGPoint(x: size.width / 2, y: size.height / 2)
        addChild(ground)

        let path = CGMutablePath()
        path.addEllipse(in: CGRect(x: size.width * 0.08, y: size.height * 0.1, width: size.width * 0.35, height: size.height * 0.2))
        let pond = SKShapeNode(path: path)
        pond.fillColor = UIColor(red: 0.56, green: 0.80, blue: 0.92, alpha: 1.0)
        pond.strokeColor = .clear
        addChild(pond)

        let fence = SKShapeNode(rectOf: CGSize(width: size.width * 0.7, height: 6), cornerRadius: 3)
        fence.fillColor = UIColor(red: 0.64, green: 0.44, blue: 0.30, alpha: 1.0)
        fence.strokeColor = .clear
        fence.position = CGPoint(x: size.width / 2, y: size.height * 0.78)
        addChild(fence)
    }

    private func addCharacters() {
        for index in 0..<characterCount {
            let node = characterNode(index: index)
            node.position = randomPoint()
            addChild(node)
            wander(node)
        }
    }

    private func characterNode(index: Int) -> SKNode {
        let body = SKShapeNode(circleOfRadius: 18)
        body.fillColor = index.isMultiple(of: 2)
            ? UIColor(red: 0.94, green: 0.74, blue: 0.70, alpha: 1.0)
            : UIColor(red: 0.80, green: 0.63, blue: 0.42, alpha: 1.0)
        body.strokeColor = UIColor.black.withAlphaComponent(0.15)

        let label = SKLabelNode(text: index.isMultiple(of: 2) ? "Pig" : "Bear")
        label.fontName = "Helvetica-Bold"
        label.fontSize = 10
        label.fontColor = UIColor.black.withAlphaComponent(0.6)
        label.verticalAlignmentMode = .center

        let container = SKNode()
        container.addChild(body)
        label.position = CGPoint(x: 0, y: -30)
        container.addChild(label)
        return container
    }

    private func wander(_ node: SKNode) {
        let destination = randomPoint()
        let move = SKAction.move(to: destination, duration: moveDuration)
        move.timingMode = .easeInEaseOut
        let rotate = SKAction.rotate(toAngle: CGFloat.random(in: -0.3...0.3), duration: moveDuration)
        let group = SKAction.group([move, rotate])
        let pause = SKAction.wait(forDuration: 0.4)
        let loop = SKAction.run { [weak self, weak node] in
            guard let self, let node else { return }
            self.wander(node)
        }
        node.run(SKAction.sequence([group, pause, loop]))
    }

    private func randomPoint() -> CGPoint {
        let margin: CGFloat = 40
        let maxX = max(margin, size.width - margin)
        let maxY = max(margin, size.height - margin)
        guard maxX > margin, maxY > margin else {
            return CGPoint(x: size.width / 2, y: size.height / 2)
        }
        let x = CGFloat.random(in: margin...maxX)
        let y = CGFloat.random(in: margin...maxY)
        return CGPoint(x: x, y: y)
    }
}

#Preview {
    FarmDemoView()
}
