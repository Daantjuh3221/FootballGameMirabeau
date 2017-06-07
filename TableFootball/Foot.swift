//
//  Foot.swift
//  Testball
//
//  Created by HuubvandeHoef on 3/14/17.
//  Copyright © 2017 HuubvandeHoef. All rights reserved.
//

import Foundation
import SpriteKit

class Foot: SKSpriteNode{
    
    //offsets of the foot
    var offset:CGFloat = 0
    var maxOffset:CGFloat = 0
    var minOffset:CGFloat = 0
    
    var Team = "TeamBlue"
    
    var counter = 60
    
    var rest:Bool = false
    var arrived:Bool = false
    
    var sensitivity:CGFloat = 10
    
    //Basic vars for the foot
    var startPos:CGFloat = 0
    var maxSpeed:CGFloat = 10
    
    //SpeedValue
    var lastSpeed:[CGFloat] = []
    var speedCounter:Int = 0
    
    let theFoot = SKSpriteNode(imageNamed: "")
    let theHead = SKSpriteNode(imageNamed: "")
    
    var positionOnStick:CGFloat = 0
    var maxOffsets:CGFloat = 0
    
    //Animation var
    var playerImages:[String] = ["","","","",""]
    var imageCounter:Int = 0
    
    //Turn sound
    var soundHardBounce:[SKAction] = []
    
    func Init(postionX: CGFloat, positionY: CGFloat, size: CGSize, name:String, colorSprite:String, gameScene: GameScene, maxOffset: CGFloat, footName:String){
        
        //Create Cube as a Foot
        // let theFoot = SKSpriteNode(imageNamed: "red")
        theFoot.texture = SKTexture(imageNamed: colorSprite)
        theFoot.size = size
        theFoot.position.x = postionX
        theFoot.position.y = positionY
        theFoot.physicsBody = SKPhysicsBody(rectangleOf: theFoot.frame.size)
        theFoot.physicsBody?.allowsRotation = false
        theFoot.physicsBody?.affectedByGravity = false
        theFoot.physicsBody?.mass = Constants.FOOT_MASS
        theFoot.physicsBody?.isDynamic = true
        theFoot.name = footName
        theFoot.zPosition = 0
        theFoot.alpha = 0.0
        gameScene.addChild(theFoot)
        
        if(colorSprite == Constants.TEAM.red.rawValue){
            //Get red team
            for i in 0...4{
            playerImages[i] = "PlayerRed" + String(i + 1)
            }
        }else{
            //Get blue team
            for i in 0...4{
                playerImages[i] = "Player" + String(i + 1)
            }
        }
        
        //get the hard bounce sound
        for i in 0...1{
            soundHardBounce.append(SKAction.playSoundFileNamed("hardbounce0" + String(i + 1) + ".wav", waitForCompletion: false))
        }
        
        //Draw the head/Player
        drawHead(sprite: playerImages[0], isFliped: true)
        theHead.zPosition = 1
        theHead.position = theFoot.position
        gameScene.addChild(theHead)
        
        rest = true
        
        positionOnStick = 0 + theFoot.position.y
        maxOffsets = (maxOffset/2) - 5
        speedCounter = 0
        
        //Set value per position
        startPos = theFoot.position.x
    }
    
    //Wekrt nog niet
    func playShotSound(){
        //This method plays a random sound whenever it touches the ball
        let randomSound:Int = Int(arc4random_uniform(2))
        run(soundHardBounce[randomSound])
    }
    
    func drawHead(sprite:String, isFliped: Bool){
         theHead.texture = SKTexture(imageNamed: sprite)
        
        if(isFliped){
            theHead.size = CGSize(width: (theHead.texture?.size().width)!/3.5, height: Constants.FOOT_HEAD_HEIGHT)
        }else{
            theHead.size = CGSize(width: ((theHead.texture?.size().width)!/3.5) * -1, height: Constants.FOOT_HEAD_HEIGHT)
        }
        
    }
    
    func clampFoots(){
        //clamp foot
        //Makes sure the foots stays within their range
        if(theFoot.position.x > startPos + maxOffsets){
            theFoot.physicsBody?.velocity.dx = 0
            theFoot.position.x = startPos + maxOffsets - 1
        }
        if(theFoot.position.x < startPos - maxOffsets){
            theFoot.physicsBody?.velocity.dx = 0
            theFoot.position.x = startPos - maxOffsets - 1
        }
        //<--- End Clamp ---->
    }
    
    func centreFoots(){
        //Return foots to centre
        theFoot.physicsBody?.velocity.dx += (startPos - theFoot.position.x) * 1
        theFoot.physicsBody?.velocity.dx *= CGFloat(0.9)
    }
    
    
    func animatePlayer(relativePosition: CGFloat){
        /*
 
         This method makes the animatiopn of the player

        print("rel: \(relativePosition)")
        print("img: \(imageCounter)")
 */
        var flipped:Bool = true
        
        if(relativePosition > 0){
            
            //Check if image must be flipped or not
            flipped = true
            
            //check which image needs to be displayed
            if(relativePosition > 40){
                imageCounter = 4
            }else if(relativePosition > 30){
                imageCounter = 3
            }else if(relativePosition > 20){
                imageCounter = 2
            }else if(relativePosition > 10){
                imageCounter = 1
            }
            
        }
        
        if(relativePosition < 0){
            //check if flipped of not
            flipped = false
            
            //And the other wat around
            if(relativePosition < -40){
                imageCounter = 4
            }else if(relativePosition < -30){
                imageCounter = 3
            }else if(relativePosition < -20){
                imageCounter = 2
            }else if(relativePosition < -10){
                imageCounter = 1
            }
        }
        if(relativePosition < 10 && relativePosition > -10){
            imageCounter = 0
        }
        drawHead(sprite: playerImages[imageCounter], isFliped: flipped)
    }
    
    func addImpulse(length: CGFloat){
        //Makes the swipe possible, so the player can shoot the ball
        theFoot.physicsBody?.applyForce(CGVector(dx:length * Constants.PLAYER_SENSITIVITY, dy:0 ))
        playShotSound()
    }
    
    func update(swipeLength: CGFloat, positionY: CGFloat){
        
        theFoot.position.y = positionOnStick + positionY
        theHead.position.y = theFoot.position.y
        
        animatePlayer(relativePosition: (startPos - theFoot.position.x))
        clampFoots()
        centreFoots()
    }
    
}