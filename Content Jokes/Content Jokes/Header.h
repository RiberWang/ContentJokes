//
//  Header.h
//  Content Jokes
//
//  Created by qianfeng on 15-1-23.
//  Copyright (c) 2015年 Riber. All rights reserved.
//

#ifndef Content_Jokes_Header_h
#define Content_Jokes_Header_h

// 1.段子 首页(推荐)


#define CONTENT_PATH @"http://ic.snssdk.com/neihan/stream/category/data/v2/?category_id=1&level=6%@&count=30&min_time=%d&iid=2600169151%@"
#define CONTENT_PATH_PART1 @"&message_cursor=-1&loc_mode=6&loc_time=1425347531&latitude=34.787278886635&longitude=113.6650190913&city=%E9%83%91%E5%B7%9E%E5%B8%82"
#define CONTENT_PATH_PART2 @"&device_id=3250992641&ac=wifi&channel=download&aid=7&app_name=joke_essay&version_code=331&device_platform=android&device_type=HUAWEI%20C8813DQ&os_api=16&os_version=4.1.2&uuid=A000004905D265&openudid=c0c677a5e558dae7"

// 1.1 推荐 精华 热门 新鲜 category_id 1开始 递增2 3 level=6开始 递减 5 4 3
#define TitleView_PATH @"http://ic.snssdk.com/neihan/stream/category/data/v2/?category_id=%@&level=%@&message_cursor=-1&loc_mode=6&loc_time=1425347531&latitude=34.787278886635&longitude=113.6650190913&city=6.953223E-31098912.136402E-3145B76.953223E-3104.470436E+085B88&count=30&min_time=%d&iid=2600169151%@"
#define TitleView_PATH_PART @"&device_id=3250992641&ac=wifi&channel=download&aid=7&app_name=joke_essay&version_code=331&device_platform=android&device_type=HUAWEI%20C8813DQ&os_api=16&os_version=4.1.2&uuid=A000004905D265&openudid=c0c677a5e558dae7"

// 1.2 精华
#define CONTENT_PATH_2 

// 1.3 热门
#define CONTENT_PATH_3

// 1.4 新鲜
//http://ic.snssdk.com/neihan/stream/category/data/v2/?category_id=1&level=3&message_cursor=-1&loc_mode=6&loc_time=1425347531&latitude=34.787278886635&longitude=113.6650190913&city=6.953223E-31098912.136402E-3145B76.953223E-3104.470436E+085B88&count=30&min_time=1425611910&iid=2600169151&device_id=3250992641&ac=wifi&channel=download&aid=7&app_name=joke_essay&version_code=331&device_platform=android&device_type=HUAWEI%20C8813DQ&os_api=16&os_version=4.1.2&uuid=A000004905D265&openudid=c0c677a5e558dae7
#define CONTENT_PATH_4 @"http://ic.snssdk.com/neihan/stream/category/data/v2/?category_id=%@&level=3&message_cursor=-1&loc_mode=6&loc_time=1425347398&latitude=34.787278886635&longitude=113.6650190913&city=6.953223E-31098912.136402E-3145B76.953223E-3104.470436E+085B88count=30&min_time=%d&iid=2600169151%@"
#define CONTENT_PATH_PART_4 @"&device_id=3250992641&ac=wifi&channel=download&aid=7&app_name=joke_essay&version_code=331&device_platform=android&device_type=HUAWEI%20C8813DQ&os_api=16&os_version=4.1.2&uuid=A000004905D265&openudid=c0c677a5e558dae7"

//1.1详情页
#define CONTENT_DETAIL_PATH @"http://isub.snssdk.com/2/data/get_essay_comments/?group_id=%@&count=20&offset=0&iid=2539854662%@"
#define CONTENT_DETAIL_PATH_PART @"&device_id=3150072610&ac=wifi&channel=baidu&aid=7&app_name=joke_essay&version_code=330&device_platform=android&device_type=HUAWEI%20U8825D&os_api=15&os_version=4.0.4&uuid=867247017609073&openudid=62e201d639b5a3"

//2.图片


#define IMAGE_PATH @"http://ic.snssdk.com/neihan/stream/category/data/v2/?category_id=2&level=6&message_cursor=-1&loc_mode=0&count=10&min_time=%d&iid=2539854662%@"
#define IMAGE_PATH_PART @"&device_id=3150072610&ac=wifi&channel=baidu&aid=7&app_name=joke_essay&version_code=330&device_platform=android&device_type=HUAWEI%20U8825D&os_api=15&os_version=4.0.4&uuid=867247017609073&openudid=62e201d639b5a3"

//3.视频


#define VIDEO_PATH @"http://ic.snssdk.com/neihan/stream/category/data/v2/?category_id=18&level=6&message_cursor=-1&loc_mode=0&count=10&min_time=%d&iid=2539854662%@"
#define VIDEO_PATH_PART @"&device_id=3150072610&ac=wifi&channel=baidu&aid=7&app_name=joke_essay&version_code=330&device_platform=android&device_type=HUAWEI%20U8825D&os_api=15&os_version=4.0.4&uuid=867247017609073&openudid=62e201d639b5a3"

// 4.发现


#define FIND_PATH @"http://ic.snssdk.com/2/essay/discovery/v2/?iid=2539854662&device_id=3250992641&ac=wifi&channel=download&aid=7&app_name=joke_essay&version_code=331&device_platform=android&device_type=HUAWEI%20C8813DQ&os_api=16&os_version=4.1.2&uuid=A000004905D265&openudid=c0c677a5e558dae7"

// 4.1热门活动
// 4.1.1
#define FIND_PATH_LATEST @"http://ic.snssdk.com/api/2/essay/zone/activity/feed/?activity_id=68&order_type=%d&count=20&max_time=%d&iid=2600169151%@"
#define FIND_PATH_LATEST_PART @"&device_id=3250992641&ac=wifi&channel=download&aid=7&app_name=joke_essay&version_code=331&device_platform=android&device_type=HUAWEI%20C8813DQ&os_api=16&os_version=4.1.2&uuid=A000004905D265&openudid=c0c677a5e558dae7"

// 4.1.2 往期
#define FIND_PATH_AGO @"http://ic.snssdk.com/api/2/essay/zone/activities/?count=30&iid=2600169151&device_id=3250992641&ac=wifi&channel=download&aid=7&app_name=joke_essay&version_code=331&device_platform=android&device_type=HUAWEI%20C8813DQ&os_api=16&os_version=4.1.2&uuid=A000004905D265&openudid=c0c677a5e558dae7"
// 4.1.2.1 往期详情 activity_id=57变化
#define FIND_PATH_AGO_DETAIL @"http://ic.snssdk.com/api/2/essay/zone/activity/feed/?activity_id=%@&order_type=2&count=20&iid=2600169151%s"
#define FIND_PATH_AGO_DETAIL_PART "&device_id=3250992641&ac=wifi&channel=download&aid=7&app_name=joke_essay&version_code=331&device_platform=android&device_type=HUAWEI%20C8813DQ&os_api=16&os_version=4.1.2&uuid=A000004905D265&openudid=c0c677a5e558dae7"

// 4.2神评论

// 4.2.1 神评论详情页
#define FIND_PATH_GOD_COMMENT @"http://ic.snssdk.com/api/2/essay/zone/god_comments/?count=20&iid=2539854662&device_id=3150072610&ac=wifi&channel=baidu&aid=7&app_name=joke_essay&version_code=330&device_platform=android&device_type=HUAWEI%20U8825D&os_api=15&os_version=4.0.4&uuid=867247017609073&openudid=62e201d639b5a3"
// 4.2.2 神评论个数
#define FIND_PATH_GOD_COMMENT_COUNT @"http://ic.snssdk.com/2/essay/zone/god_comments_count/?min_time=%d&iid=2600169151%@"
#define FIND_PATH_GOD_COMMENT_COUNT_PART @"&device_id=3250992641&ac=wifi&channel=download&aid=7&app_name=joke_essay&version_code=331&device_platform=android&device_type=HUAWEI%20C8813DQ&os_api=16&os_version=4.1.2&uuid=A000004905D265&openudid=c0c677a5e558dae7"

// 4.3 详情页

#define FIND_PATH_DETAIL @"http://ic.snssdk.com/neihan/stream/category/data/v2/?category_id=%@&level=6%@count=10&min_time=%d&iid=2600169151%@"
#define FIND_PATH_DETAIL_PART1 @"&message_cursor=-1&loc_mode=6&loc_time=%d&latitude=34.787604434983&longitude=113.66552031637&city=%E9%83%91%E5%B7%9E%E5%B8%82&"
#define FIND_PATH_DETAIL_PART2 @"&device_id=3250992641&ac=wifi&channel=download&aid=7&app_name=joke_essay&version_code=331&device_platform=android&device_type=HUAWEI%20C8813DQ&os_api=16&os_version=4.1.2&uuid=A000004905D265&openudid=c0c677a5e558dae7"

//5.用户信息页


#define USERINFO_PATH @"http://isub.snssdk.com/neihan/user/profile/v1/?user_id=%@&iid=2539854662%@"
#define USERINFO_PATH_PART @"&device_id=3150072610&ac=wifi&channel=baidu&aid=7&app_name=joke_essay&version_code=330&device_platform=android&device_type=HUAWEI%20U8825D&os_api=15&os_version=4.0.4&uuid=867247017609073&openudid=62e201d639b5a3"

//5.1常见问题页面

#define QUESTION_PATH @"http://s0.pstatp.com/static/essay/jokeEssayHelp2.4.html"

//5.2投稿页

#define UGC_PATH @"http://ic.snssdk.com/2/essay/zone/user/posts/?user_id=%@&count=30&iid=2539854662%@"
#define UGC_PATH_PART @"&device_id=3150072610&ac=wifi&channel=baidu&aid=7&app_name=joke_essay&version_code=330&device_platform=android&device_type=HUAWEI%20U8825D&os_api=15&os_version=4.0.4&uuid=867247017609073&openudid=62e201d639b5a3"

//5.3评论页

#define COMMENT_PATH @"http://isub.snssdk.com/14/update/user/?count=20&user_id=%@&min_create_time=0&type=comment&iid=2539854662%@"
#define COMMENT_PATH_PART @"&device_id=3150072610&ac=wifi&channel=baidu&aid=7&app_name=joke_essay&version_code=330&device_platform=android&device_type=HUAWEI%20U8825D&os_api=15&os_version=4.0.4&uuid=867247017609073&openudid=62e201d639b5a3"

// 5.4 收藏的段子

#define REPIN_PATH @"http://ic.snssdk.com/2/essay/zone/user/favorites/?user_id=%@&count=30&iid=2600169151%@"
#define REPIN_PATH_PART @"&device_id=3250992641&ac=wifi&channel=download&aid=7&app_name=joke_essay&version_code=331&device_platform=android&device_type=HUAWEI%20C8813DQ&os_api=16&os_version=4.1.2&uuid=A000004905D265&openudid=c0c677a5e558dae7"

#endif
