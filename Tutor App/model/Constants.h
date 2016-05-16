//
//  Constants.h
//  Tutor App
//
//  Created by AnCheng on 9/10/15.
//  Copyright (c) 2015 ancheng1114. All rights reserved.
//

#ifndef Tutor_App_Constants_h
#define Tutor_App_Constants_h

#define GREEN_COLOR  @"#6FBD39"
#define GRAY_COLOR  @"#B8B7B6"

#define USER_ROLE   @"ROLE"

#define StripeTestKey           @"sk_test_tor3MAVbaKkzZ43YWKDHbO06"
#define StripePublishableKey    @"pk_test_du7RcaJZ7UpZyCZCGYLY1y4G"

#define SERVER_URL @"http://wsddev2.com/dev/tutor/api/"
#define SERVER_URL_PROFILE @"http://wsddev2.com/dev/tutor/upload/profile_pic/"

#pragma Define of the UserInfo.

#define account_member_id           @"member_id"
#define account_type                @"account_type"
#define account_first_name          @"first_name"
#define account_last_name           @"last_name"
#define account_email               @"email"
#define account_email_Cap           @"Email"
#define account_password            @"password"
#define account_phone               @"phone"
#define account_birthday            @"birth_date"
#define account_school_attending    @"school_attending"
#define account_grade_level         @"grade_level"
#define account_subjects            @"subjects"
#define account_device_token        @"device_token"
#define account_student             @"student"
#define account_tutor               @"tutor"
#define account_course_tutor        @"course"
#define account_title_tutor         @"title"
#define account_university_tutor    @"university"
#define account_city                @"city"
#define account_state               @"state"
#define account_country             @"country"
#define account_about_me            @"about_me"
#define account_profile_image       @"profile_image"
#define available_tutors            @"available_tutors"
#define account_tutor_rate          @"tutor_rate"
#define account_current_session     @"current_session"

#define account_tutor_id            @"tutor_id"
#define account_tutoring_session    @"session"

#define tutoring_session_id         @"session_id"
#define session_duration            @"duration"
#define payment_transaction_id      @"transaction_id"
#define tutoring_history_sessions   @"sessions"

#define session_is_accepted         @"accepted"


#pragma Quickblox Sign Password
#define quickbloxPass               @"11111111"

// API URL
#define API_SIGN_IN                 @"checkUserAuthentication"
#define API_SIGN_UP                 @"userSignUp"
#define API_FORGOT_PASSWORD         @"forgotPassword"
#define API_EDIT_ACCOUNT            @"editAccount"
#define API_GET_ACCOUNT             @"getAccount"
#define API_AVAILABLE_TUTORS        @"availableTutors"
#define API_HASCURRENTTUTORSESSION  @"hasCurrentTutorSession"
#define API_INITIATETUTORSESSION    @"initiateTutoringSession"
#define API_PAYFOR_SESSION          @"payForSession"
#define API_SESSION_ACCEPT          @"tutorAcceptSession"
#define API_SESSION_HISTORY         @"sessionHistory"
#define API_END_SESSION             @"endSession"


#endif
