//
//  GameScene.swift
//  mogura
//
//  Copyright © 2015年 shoeisha. All rights reserved.
//

import SpriteKit

class GameScene : SKScene {
    
    // もぐらのスプライトの配列
    var moguras: [SKSpriteNode] = []
    
    // もぐらの初期座標の配列
    let moguraPosition = [CGPoint(x: 100,y: 165), CGPoint(x: 275,y: 165), CGPoint(x: 100,y: 15), CGPoint(x: 275,y: 15)]
    
    // スコア表示用
    var score = 0
    var scoreLabel: SKLabelNode?
    
    // カウンタ表示用
    var timeCount = 30
    var countLabel: SKLabelNode?
    var timer = Timer()
    
    // 効果音用
    var seAction: SKAction?
    
    // シーンが表示された時に呼ばれる
    override func didMove(to view: SKView) {
        
        // 背景画像のスプライトを配置する
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.5)
        addChild(background)
        
        // 穴画像のスプライトを配置する
        let hole1 = SKSpriteNode(imageNamed: "hole")
        hole1.position = CGPoint(x: 100, y: 200)
        addChild(hole1)
        
        moguras.append(SKSpriteNode(imageNamed: "mogura"))
        moguras[0].position = moguraPosition[0]
        
        addChild(moguras[0])
        
        let hide1 = SKSpriteNode(imageNamed: "bg_hide")
        hide1.position = CGPoint(x: 100, y: 176)
        hide1.isUserInteractionEnabled = false;
        addChild(hide1)
        
        let hole2 = SKSpriteNode(imageNamed: "hole")
        hole2.position = CGPoint(x: 275, y: 200)
        addChild(hole2)
        
        moguras.append(SKSpriteNode(imageNamed: "mogura"))
        moguras[1].position = moguraPosition[1]
        addChild(moguras[1])
        
        let hide2 = SKSpriteNode(imageNamed: "bg_hide")
        hide2.position = CGPoint(x: 275, y: 176)
        hide2.isUserInteractionEnabled = false;
        addChild(hide2)
        
        let hole3 = SKSpriteNode(imageNamed: "hole")
        hole3.position = CGPoint(x: 100, y: 50)
        addChild(hole3)
        
        moguras.append(SKSpriteNode(imageNamed: "mogura"))
        moguras[2].position = moguraPosition[2]
        addChild(moguras[2])
        
        let hide3 = SKSpriteNode(imageNamed: "bg_hide")
        hide3.position = CGPoint(x: 100, y: 26)
        hide3.isUserInteractionEnabled = false;
        addChild(hide3)
        
        let hole4 = SKSpriteNode(imageNamed: "hole")
        hole4.position = CGPoint(x: 275, y: 50)
        addChild(hole4)
        
        moguras.append(SKSpriteNode(imageNamed: "mogura"))
        moguras[3].position = moguraPosition[3]
        addChild(moguras[3])
        
        let hide4 = SKSpriteNode(imageNamed: "bg_hide")
        hide4.position = CGPoint(x: 275, y: 26)
        hide4.isUserInteractionEnabled = false;
        addChild(hide4)
        
        // スコアとカウンターを表示する
        let scoreLabel = SKLabelNode (fontNamed: "ArialRoundedMYBold")
        scoreLabel.fontSize = 32
        scoreLabel.fontColor = UIColor.brown
        scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        scoreLabel.position = CGPoint(x: 10, y: 610)
        addChild(scoreLabel)
        self.scoreLabel = scoreLabel
        
        let countLabel = SKLabelNode (fontNamed: "ArialRoundedMYBold")
        countLabel.fontSize = 32
        countLabel.fontColor = UIColor.brown
        countLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        countLabel.position = CGPoint(x: 10, y: 570)
        addChild(countLabel)
        self.countLabel = countLabel
        
        // 効果音
        let seAction = SKAction.playSoundFileNamed("se.mp3", waitForCompletion: false)
        self.seAction = seAction
        
        reset()
    }
    
    // もぐらを上下させるアクションを設定する
    func moguraAction(_ sprite: SKSpriteNode) {
        
        // 1秒〜3秒 待機する
        let action1 = SKAction.wait(forDuration: 2.0, withRange: 2.0)
        
        // 現在の座標から 1 秒間かけて y 方向へ 100 移動させる
        let action2 = SKAction.moveBy(x: 0, y: 100, duration: 1.0)
        
        // 0秒〜2秒 待機する
        let action3 = SKAction.wait(forDuration: 1.0, withRange: 2.0)
        
        // 現在の座標から 1 秒間かけて y 方向へ -100 移動させる
        let action4 = SKAction.moveBy(x: 0, y: -100, duration: 1.0)
        
        // action1〜4 を連続的に実行する
        let actionSequence = SKAction.sequence([action1, action2, action3, action4])
        
        // actionSequence を繰り返し実行する
        let actionRepeat = SKAction.repeatForever(actionSequence)
        
        sprite.run(actionRepeat)
    }
    
    // タッチイベント
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches {
            
            // タッチされた場所の座標を取得.
            let location = touch.location(in: self)
            
            // タッチされたノードを得る
            let touchNode = self.atPoint(location)
            
            for mog in moguras {
                if touchNode == mog {
                    touchedMogura(mog)
                }
            }
            
        }
    }
    
    // もぐらを叩いた時に呼ばれる
    func touchedMogura(_ sprite: SKSpriteNode) {
        
        // スコアを加算する
        score += 1
        scoreLabel?.text = "SCORE： \(score)"
        
        // 叩かれたもぐらのアクションを止めて非表示にする
        sprite.removeAllActions()
        sprite.isHidden = true
        
        // 回転しながら飛ばされるもぐら
        let hitMogura = SKSpriteNode(imageNamed: "mogura_hit")
        hitMogura.position = sprite.position
        
        let action1 = SKAction.rotate(byAngle: CGFloat(M_PI) * 2, duration: 1)
        let action2 = SKAction.moveBy(x: 0, y: 200, duration: 1)
        let action3 = SKAction.fadeOut(withDuration: 1)
        let action4 = SKAction.removeFromParent()
        let action123 = SKAction.group([action1, action2,action3])
        let sequence = SKAction.sequence([action123, action4])
        
        
        addChild(hitMogura)
        
        // 効果音を鳴らす
        run(seAction!)
        
        hitMogura.run(sequence, completion: {
            [unowned self] in
            
            // もぐらの座標を初期値に戻して上下のアニメーションを再開させる
            if let index = self.moguras.index(of: sprite) {
                sprite.position = self.moguraPosition[index]
            }
            sprite.isHidden = false
            self.moguraAction(sprite)
            })
    }
    
    // リセットを行う
    func reset() {
        
        // スコアと残り時間をリセットする
        score = 0
        timeCount = 30
        
        scoreLabel?.text = "SCORE： \(score)"
        countLabel?.text = "TIME： \(timeCount)"
        
        // タイマーを開始
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(GameScene.timerUpdate), userInfo: nil, repeats: true)
        
        for index in 0...3 {
            moguras[index].position = moguraPosition[index]
            moguraAction(moguras[index])
        }
        
        let start = SKSpriteNode(imageNamed: "start")
        start.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.5)
        
        // スタートを表示する
        let action1 = SKAction.wait(forDuration: 0.5)
        let action2 = SKAction.fadeOut(withDuration: 0.5)
        let action3 = SKAction.removeFromParent()
        let sequence = SKAction.sequence([action1, action2, action3])
        
        addChild(start)
        start.run(sequence)
        
    }
    
    // タイマーが発火した時に呼ばれる
    func timerUpdate() {
        timeCount -= 1
        
        if timeCount >= 0 {
            countLabel?.text = "TIME： \(timeCount)"
        } else {
        
            // タイマーを停止させる
            timer.invalidate()
            
            let gameOverLabel = SKSpriteNode(imageNamed: "gameover")
            gameOverLabel.position = CGPoint(x: self.size.width * 0.5, y: 480)
            addChild(gameOverLabel)
            
            let action1 = SKAction.wait(forDuration: 1)
            let action2 = SKAction.fadeOut(withDuration: 0.5)
            let action3 = SKAction.removeFromParent()
            let sequence = SKAction.sequence([action1, action2, action3])
            
            gameOverLabel.run(sequence, completion: {
                [unowned self] in
                
                // ゲームオーバー画面に遷移する
                let gameOverScene = GameOverScene(size: self.size)
                gameOverScene.score = self.score
                let skView = self.view as SKView!
                gameOverScene.scaleMode = SKSceneScaleMode.aspectFit
                skView?.presentScene(gameOverScene)
                })
        }
    }
    
}
