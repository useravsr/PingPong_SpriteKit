//
//  GameScene.swift
//  PingPong
//
//  Created by Arthur Dos Reis on 01/07/23.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var bola = SKSpriteNode()
    var player = SKSpriteNode()
    var oponente = SKSpriteNode()
    
    var playerScore = SKLabelNode()
    var oponenteScore = SKLabelNode()
    
    var score = (playerScore: 0, oponenteScore: 0)
    
    var forca: Int = 8

    override func didMove(to view: SKView) {
        
        bola = self.childNode(withName: "bola") as! SKSpriteNode
        
        player = self.childNode(withName: "player") as! SKSpriteNode
        player.position.x = (-self.frame.width/2) + 100

        oponente = self.childNode(withName: "oponente") as! SKSpriteNode
//        oponente.position.x = (self.frame.width / 2) + 170

        playerScore = self.childNode(withName: "playerScore") as! SKLabelNode
        oponenteScore = self.childNode(withName: "oponenteScore") as! SKLabelNode
        
        let borda = SKPhysicsBody(edgeLoopFrom: self.frame)
        borda.friction = 0
        borda.restitution = 1
        self.physicsBody = borda
        
        startGame()
        
    }
    
    func startGame(){
        
        score.playerScore = 0
        score.oponenteScore = 0
        
        updateScoreLabel()
        bola.physicsBody?.applyImpulse(CGVector(dx: impulsoAleatorio() * forca, dy: impulsoAleatorio() * forca))
    }
    
    func updateScoreLabel(){
        
        playerScore.text = String(score.playerScore)
        oponenteScore.text = String(score.oponenteScore)
        
    }
    
    func addScore(playerQueMarcou: SKSpriteNode){
        var impulso: CGVector!
        
        if (playerQueMarcou == player){
            score.playerScore += 1
            impulso = CGVector(dx: forca, dy: impulsoAleatorio() * forca)
        }else {
            score.oponenteScore += 1
            impulso = CGVector(dx: -forca, dy: impulsoAleatorio() * forca)
        }
        
        updateScoreLabel()
        resetBall()
        if(score.playerScore < 10 && score.oponenteScore < 10){
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300)) { 
                self.bola.physicsBody?.applyImpulse(impulso)
            }

        }
    }
    
    func resetBall(){
        
        bola.position = CGPoint(x: 0, y: 0)
        bola.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        
    }
    
    func impulsoAleatorio() -> Int{
        
        let numero = Int.random(in: 0...9)
        return numero % 2 == 0 ? 1 : -1
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            let location = touch.location(in: self)
            
            if location.x < 0{
                player.run(SKAction.moveTo(y: location.y, duration: 0.1))
            }else if location.x > 0 {
                oponente.run(SKAction.moveTo(y: location.y, duration: 0.1))
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            let location = touch.location(in: self)
            
            if location.x < 0{
                player.run(SKAction.moveTo(y: location.y, duration: 0.1))
            }else if location.x > 0 {
                oponente.run(SKAction.moveTo(y: location.y, duration: 0.1))
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        if bola.position.x < player.position.x{
            addScore(playerQueMarcou: oponente)
        } else if bola.position.x > oponente.position.x{
            addScore(playerQueMarcou: player)
        }
    }
}
