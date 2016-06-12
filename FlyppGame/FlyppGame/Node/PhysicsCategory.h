//
//  PhysicsCategory.h
//  FlyppGame
//
//  Created by dingjianjaja on 16/6/2.
//  Copyright © 2016年 dingjian. All rights reserved.
//

#ifndef TextShooter_PhysicsCategory_h
#define TextShooter_PhysicsCategory_h

typedef NS_OPTIONS(uint32_t,PhysicsCategory){
    PlayerCategory         =  1 << 1,
    EnemyCategory          =  1 << 2,
    PlayerMissileCategory  =  1 << 3
};




#endif /* PhysicsCategory_h */
