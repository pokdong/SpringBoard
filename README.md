# SpringBoard
In-depth study for Spring framework

- Sample : http://xeyez.mooo.com:8080/board/list

## 0.1
- [X] 기본 CRUD
 -  [X] Conncetion Pool 적용 (c3p0 사용)
 -  [X] myBatis 적용
- [X] 일괄 Exception 처리

### 0.1.1
- [X] Paging 처리

### 0.1.2
- [X] 게시글 검색
- [X] Paging 및 검색 수행 후 CRUD 작업시 Parameter 정보 유지

## 0.2
- [X] 댓글 처리 (AJAX 이용)
 - [X] 무한 Scrolling
 - [X] CRUD 및 Animation

## 0.3
- [X] AOP, Transaction 처리
 - [X] 댓글수, 게시글 조회수 처리 (AOP, Transaction)
  - [X] 게시판 화면에서 댓글수 클릭하면 댓글 부분으로 이동.

## 0.4
- File upload 기능
 - [X] 일반 Form Tag 이용 파일 추가
 - [X] AJAX 이용 Drag & Drop 파일 추가
   - [X] IE 10 이하거나 Mobile인 경우 숨김
 - Transaction
    - [X] 게시글 추가일 때 첨부파일 첨부일 경우
    - [X] 이미 등록된 게시글의 첨부파일 수정 (전체 삭제 후 다시 추가)
    - [X] 게시글 삭제일 때 첨부파일도 삭제

 - [X] 첨부된 파일 클릭시 Image일 경우 Lightbox 적용하여 바로 보기

## 0.5
- Spring Security

### 0.5.1
 - [X] Log-in
 - [X] Log-out
 - [X] 자동 Log-in (Remeber me)
 - [X] 회원가입 (Sign-in)
 - [X] Profile
 - [X] 회원탈퇴
 - [X] 접근 권한 제어 (글 쓰기, 수정, Profile)

### 0.5.2
 - [X] 로그인된 사용자에 한하여 댓글 작성,수정,삭제 허용
   - [X] URL로 임의 접근시 메인화면으로 차단 및 Redirect
 - [X] 게시글 쓰기, 수정, 삭제 URL로 임의 접근시 차단 및 Redirect
 - [X] Profile 접근시 로그인 유도
 - [X] 회원 탈퇴 URL로 임의 접근시 차단 및 Redirect
 - [X] 글 쓰기, 수정 및 댓글 작성시 로그인된 ID 사용.

### 0.5.3
 - [X] 회원 정보 수정 (Profile Image, 닉네임, 비밀번호) (AJAX 이용)
 - [X] Upload form 하나로 통합. 만약 IE 10 이하면 해당 form을 숨기지 않고, Click만 지원.
 - [X] 로그인, 로그아웃 Form 입력 검증 방법을 AJAX로 변경. (Page 변경없이 현재 Page만 사용.
 - [X] 같은 ID로 동시 로그인 방지

## TBA
- Spring Security 심화
 - [ ] 익명 게시글 쓰기/수정 권한 부여
 - [ ] 비밀글
 - [ ] ID/비밀번호 찾기
 - [ ] 목록 화면에 ID / 이전 작성자 대신 현재 닉네임 표시
   - (만약, 닉네임을 변경하면 이전 작성글까지 변경되어야 하므로 DB 설계 생각 필요.)

- AJAX
 - [ ] 추천/비추천
 
- 기타
 - 공지 게시글
 - 전체 Template 교체
 - Mobile일 경우 게시글 Form 재구성 (XE 처럼)
