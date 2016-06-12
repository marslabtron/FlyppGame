//
//  Geometry.h
//  FlyppGame
//
//  Created by dingjianjaja on 16/6/2.
//  Copyright © 2016年 dingjian. All rights reserved.
//

#ifndef TextShooter_Geometry_h
#define TextShooter_Geometry_h

//向量乘法
static inline CGVector VectorMultiply(CGVector v,CGFloat m){
    return CGVectorMake(v.dx * m, v.dy * m);
}
//两点向量
static inline CGVector VectorBetweenpoints(CGPoint p1, CGPoint p2){
    return CGVectorMake(p2.x - p1.x, p2.y - p1.y);
}
//向量长度
static inline CGFloat VectorLength(CGVector v){
    return sqrtf(powf(v.dx, 2) + powf(v.dy, 2));
}
//两点距离
static inline CGFloat PointDistance(CGPoint p1,CGPoint p2){
    return sqrtf(powf(p2.x - p1.x, 2) + powf(p2.y - p1.y, 2));
}

#endif /* Geometry_h */
