# ToYou iOS

## Firebase 데이터 구조
C = Collection  
D = Document
${variable} = 변수명. 예를 들어 ${userName} 은 "이동규" 로 치환해서 생각하라는 의미임

### 유저
- Users (C) : 회원 리스트
    - ${Email} (D) - String : 이메일 = 아이디
    
      |  속성 이름  |  타입  |  설명  |
      |---|---|---|
      |  phoneNumber  |  String  |  휴대폰 번호  |
      |  name  | String  |  이름 |
      |  partner |  String |  여친남친 아이디 |
      | createdAt  | Datetime  |  가입 일자 |
      | gender | Boolean  |  성별(남자 : true, 여자 : false) |
      
- Events (C) : 캘린더 일정 리스트 
    -  ${id} (D) - Int
    
    |  속성 이름  |  타입  |  설명  |
    |---|---|---|
    | author | String | 작성자 아이디 |
    | title | String | 제목 |
    | datetime | Datetime | 일시 |
    | place | String | 장소 |
    | createdAt | Datetime | 이벤트 생성 일시 |
    | lastUpdatedAt | Datetime | 마지막 수정 일시 (이벤트 생성 일시와 포스팅의 마지막 수정일시가 다를 수 있기 때문) |
    | contributors | Array(String) | 일정 참여자 |
    | postTitle | String | 추억 포스팅 제목 |
    | postContent | String | 추억 포스팅 내용 |
    | postImages | Array(String) | 포스팅 이미지 주소 배열 |
    
- RequestPartners (C) : 파트너 요청 리스트 (최초 가입 시 커플 매칭 정보) 
    - ${userId} (D) - String
    |  속성 이름  |  타입  |  설명  |
    |---|---|---|
    | partner | String | 상대방 아이디 |
    
- ChatLogs (C) : 채팅 로그 리스트
    - ${id} (D) - Int
    
    |  속성 이름  |  타입  |  설명  |
    |---|---|---|
    | sender | String | 송신자 아이디 |
    | receiver | String | 수신자 아이디 |
    | content | String | 메세지 내용 |
    | sentAt | Datetime | 메세지 전송 일시 |
    | readAt | Datetime | 메세지 읽은 일시 |
    | type | Int | 메세지 타입(평문, 이미지, 이벤트 포스팅 등) |
    | eventId | Int | 이벤트 포스팅 참조 | 
