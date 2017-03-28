//
//  GameScene.swift
//  Testball
//
//  Created by HuubvandeHoef on 3/14/17.
//  Copyright © 2017 HuubvandeHoef. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    var canvas:SKSpriteNode = SKSpriteNode()
    
    //Create the vartiables
    var theBall:Ball = Ball()
    var firstStick = Stick()
    var secondStick = Stick()
    
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        
        //Init the ball
        if(self.childNode(withName: "ball") != nil){
            theBall = self.childNode(withName: "ball") as! Ball
            theBall.Init(gamescene: self)
        }
     
        //firstStick
        if(self.childNode(withName: "stick01") != nil){
            firstStick = self.childNode(withName: "stick01") as! Stick
            firstStick.Init(amountOfFeets: 1, positionX: 100, gameScene: self, sprite:"red")
        }
        //Secondstick
        if(self.childNode(withName: "stick02") != nil){
            secondStick = self.childNode(withName: "stick02") as! Stick
            secondStick.Init(amountOfFeets: 1, positionX: 100, gameScene: self, sprite:"blue")
        }
    }
    
    override func sceneDidLoad() {
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        
        switch contact.bodyA.node?.name {
        case "ball"?:
            firstBody = contact.bodyA
            secondBody = contact.bodyB
            break;
        case "cube"?:
            firstBody = contact.bodyA
            secondBody = contact.bodyB
            break;
        default:
            firstBody = contact.bodyB
            secondBody = contact.bodyA
            
            if(secondBody.node?.name == "ball"){
                secondBody = firstBody
                firstBody = contact.bodyB
            }
            break;
        }
    
        //Apply tthe collision with the walls
        if(firstBody.node?.name == "ball" && secondBody.node?.name == "wall"){
            theBall.collidesWithWallVertical()
        }
        if(firstBody.node?.name == "ball" && secondBody.node?.name == "walls"){
            theBall.collidesWithWallHorizintal()
        }
        
        //Check if there is made a goal
        if(firstBody.node?.name == "ball" && secondBody.node?.name == "goal"){
            theBall.didScored()
        }
        
        //Check if there is made a goal
        if(firstBody.node?.name == "ball" && secondBody.node?.name == "foot"){
            theBall.collidesWithFoot(foot: secondBody.node!)
        }
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        //Update all objects
        firstStick.update()
        secondStick.update()
        theBall.update()
    }
    
    
}
