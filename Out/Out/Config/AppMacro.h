//
//  AppMacro.h
//  Out
//
//  Created by Jolie_Yang on 2017/3/14.
//  Copyright © 2017年 Jolie_Yang. All rights reserved.
//

#ifndef AppMacro_h
#define AppMacro_h
#if DEBUG
// 开发
#define kSERVER_HOST @"http://express.mistkafka.tk"
#define kSERVER_URL @"http://express.mistkafka.tk/api1/"
#define kPHOTO_NAME @"photo"
#define kPHOTO_URL @"http://express.mistkafka.tk/api1/photo?photoId="
#define kPHOTO_DEFAULT @"http://express.mistkafka.tk/api1/photo?photoSrc=system&photoId=default"
#define SUCCESS_STATUS @"success"
#else
// 生产
#define kSERVER_HOST @"http://express.mistkafka.tk"
#define kSERVER_URL @"http://express.mistkafka.tk/api1/"
#define kPHOTO_NAME @"photo"
#define kPHOTO_URL @"http://express.mistkafka.tk/api1/photo?photoId="
#define kPHOTO_DEFAULT @"http://express.mistkafka.tk/api1/photo?photoSrc=system&photoId=default"
#define SUCCESS_STATUS @"success"
#endif

#define OUT_NICK_NAME @"com.spider.out.developer.nickname"
#define OUT_NAME_NUMBER @"com.spider.out.developer.name.number"
#define OUT_TOKEN @"com.spider.out.develop.token"

#define LIMIT_TEXT_LENGTH 100

// Out请求
#define ENABLE_SERVER 0 // 是否开启服务器请求
#define OUT_MOOD_BG_IMAGENAME @"yellow_girl"
#define OUT_DEFAULT_BGIMAGE [UIImage imageNamed:OUT_MOOD_BG_IMAGENAME]

// Running
#define Running_Base_URL @"http://121.41.41.41:17179/api/"
#define Running_Add_Member @"running-members"
#define Running_Add_Week @"running-weeks"
#define Running_Add_Record @"running-records"

// 颜色
#define Black1 UIColorFromRGB(0x474749)
#define Black2 UIColorFromRGB(0x24252C)
#define System_Black UIColorFromRGB(0x28292B)// 导航栏设置该颜色，渲染后的颜色为Black1
#define System_White UIColorFromRGB(0xECECED)
#define White UIColorFromRGB(0xFFF)

#define Xcode_Black UIColorFromRGB(0x24252B)
#define Apple_Gold UIColorFromRGB(0xD2C2AC)
#define Apple_Silver UIColorFromRGB(0xD5D5D8)
#define Apple_SpaceGray UIColorFromRGB(0xA4A4A8)
#define Apple_RoseGold UIColorFromRGB(0xCBB0A9)
#define Apple_Black UIColorFromRGB(0x383A3E)
#define Swift_Orange UIColorFromRGB(0xE38D46)

#define Birthday_Bg_Gray UIColorFromRGB(0x5E5E5E)
#define Birthday_Icon_Gray UIColorFromRGB(0x737373)
#define Birthday_Line_Gray UIColorFromRGB(0xC8C8C8)
#define Birthday_Gray UIColorFromRGB(0x757575) // 生辰应用

#define Alipay_Bg UIColorFromRGB(0xEBEEEC)
#define Table_Bg UIColorFromRGB(0xF1F3F5)
#define App_Bg Alipay_Bg
#define PlaceHolder_Gray UIColorFromRGB(0xBAB9BF)

#define Running_Record_Not_Achieve UIColorFromRGB(0xFFFE3C)
#define Running_Record_Take_Leave UIColorFromRGB(0x62A14E)

#define System_Sub_Tone Swift_Orange
#define System_Main_Tone Black2
#define System_Nav_Black System_Main_Tone
#define System_Nav_White System_White
#define System_Nav_Gray Birthday_Icon_Gray
#define HourMinute_Bg Black1

#define White_Icon_Color UIColorFromRGB(0xFFFFFF)
#define Gray_Icon_Color UIColorFromRGB(0xECECED)

// 图片
#define White_Back_Icon_Name @"picture_back"
#define White_Check_Icon_Name @"picture_ok"
#define White_Camera_Icon_Name @"picture_camera"
#define White_Detail_Icon_Name @"detail_icon"
#define Gray_Nav_Back_Icon_Name @"nav_back"
#define Gray_Nav_Check_Icon_Name @"nav_check"

#define Default_Image [UIImage imageNamed: @"tab_icon_01_normal"]
#endif /* AppMacro_h */
