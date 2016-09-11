# SpringBoard
In-depth study for Spring framework

## 0.1
- [X] 기본 CRUD
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
 - [X] 작성중인 게시글의 첨부파일 삭제 (unload 이용)
 - Transaction
    - [X] 게시글 추가일 때 첨부파일 첨부일 경우
    - [X] 이미 등록된 게시글의 첨부파일 수정 (전체 삭제 후 다시 추가)
    - [X] 게시글 삭제일 때 첨부파일도 삭제

 - [X] 첨부파일이 Image일 경우 Lightbox 적용.

## 0.5
- Log-in / Log-out

### 0.5.1
- Intercepor 이용
 - [ ] Log-in
 - [ ] Log-out
 - [ ] 자동 Log-in (Remeber me)

### 0.5.2
- Spring Security 적용
 - [ ] Log-in
 - [ ] Log-out
 - [ ] 자동 Log-in (Remeber me)
 - [ ] 회원가입 (Sign-in)


## TBA
- Spring Security 심화
 - [ ] 목록 화면에 ID 대신, 닉네임 표시
 - [ ] 익명/회원 게시글 작성 권한 분할
 - [ ] 회원정보 수정
 - [ ] ID/비밀번호 찾기

- AJAX
 - [ ] 추천/비추천
 
- 기타
 - 공지 게시글
 - 전체 Template 교체
 - Mobile일 경우 게시글 Form 재구성 (XE 처럼)
