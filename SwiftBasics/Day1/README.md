##  Xcode 및 GitHub 설치

- iOS 프로그램을 개발할 수 있는 소프트웨어 개발 도구(Software Development Kit, 이하 SDK)를 포함하고 있는 Xcode를 설치한다.
- Xcode 실행하고 새로운 Playground를 생성한 후 "Hello, iOS World" 메시지를 출력하는 프로그램을 구현하고 실행한다.
- 구현한 소스 코드를 저장하고 관리하기 위한 github 저장소를 생성한다.
- github 저장소에 위키 페이지를 만들고 markdown 문법으로 문서를 작성한다.
- Playground 와 github 저장소를 연결해 소스 코드를 저장소에 추가한다.
- Playground 에서 소스코드를 수정한 후 수정된 내용을 github 저장소에 반영한다.

<br/><br/>


## 1. 버전관리 시스템 : SVN
> 중앙에 바로 저장 (commit)


## 2. “분산” 버전관리 시스템 : Git
>- 각각의 사용자가 자신만의 저장소를 가지고 있음
>- 즉, 중앙으로 보내지 않아도 개인 저장소에 저장할 수 있음(commit)
>- 개인저장소에 있는 내용을 중앙에 저장(push)
>- 네트워크 때문에 이렇게 분산으로 만듦
    
*차이 : 분산 버전관리 시스템은 사용자 각자가 자신만의 저장소를 가지고 있음*


## 3. Git 주요 명령어
* *git init*
> 내부 저장소 생성. 프로젝트 여러 개 관리할 때는 최상위 폴더에서만 쓰는 것이 좋음
* *git add <관리할 파일이름>*
> 로컬에서 관리할 파일을 워크스페이스에서 stage(index)에 올림. add한 후부터 git의 관리 대상이 됨. 파일이름 대신 "."을 넣으면 현재 디렉토리의 모든 파일을 올릴 수 있음
* *git status*
> 현재 깃상에서 관리할 수 있는 파일들의 상태 조회 가능. 추가/수정 후 add 하지 않은 파일은 빨간색으로 표시되며, commit 할 준비가 된 파일은 초록색으로 표시됨
* *git commit -m “message”*
> stage(index)에 있는 내용을 내부 저장소에 스냅샷으로 저장. 즉, 이전 버전의 파일과의 차이점만 +/-로 기록함. commit한 후부터 파일의 버전을 관리할 수 있으며, 원격(중앙) 저장소에 올릴 수 있음
* *git commit --amend*
> 커밋 메시지 수정. 맨 마지막 커밋만 수정 가능.
* *git branch*
> 로컬의 branch 목록 조회
* *git branch -r*
> 원격의 branch 목록 조회
* *git branch <브랜치이름>*
> 새 branch 만듦
* *git checkout <브랜치이름>*
> 해당 브랜치로 이동
* *git checkout <commit_id>*
> commit_id 상태로 이동. 이렇게 체크아웃된 상태는 브랜치위에 올라가 있지 않음
* *git merge <브랜치이름>*
> 브랜치 합침
* *git branch -d <브랜치이름>*
> merge한 브랜치 삭제
* *git branch -D <브랜치이름>*
> merge 안 한 브랜치 삭제
* *git branch <브랜치이름> <commit_id>*
> commit_id에 브랜치를 새로 만듦. 즉, 이전 커밋 포인트에서 브랜치 만들 수 있음 
* *git log*
> 내가 커밋한 로그를 찍어줌
* *git reflog*
> 내가 커밋한 로그를 요약해서 찍어줌
* *git diff*
> 로컬의 branch간 비교, 로컬과 리모트의 내용 비교, commit 간 비교, pull request 내용과 비교 등을 할 수 있음
* *git reset <id> —hard*
> 버전 되돌림. 단, 되돌린 이력을 남기지 않음. 되도록 안 쓰는 게 좋음.
* *git revert <id>*
> 버전 되돌림. 되돌린 이력을 남김. 되도록 안 쓰는 게 좋음.
* *git remote add origin <저장소 주소>*
> 현재 내부 저장소와 원격 저장소 연결
* *git remote -v*
> 원격 저장소 설정 확인
* *git push <원격저장소> <branch>*
> 원격 저장소에 저장. 보통 git push origin master 라고 씀
* *git clone <저장소 주소>*
> 원격 저장소에서 복사본 가져옴. 보통 다른 사람의 깃헙에서 프로젝트 파일을 다운받을 때 씀
* *git pull <원격저장소> <branch>*
> 원격 저장소에서 최신 변경사항 받아옴. 로컬로 가져온 후 워크스페이스까지 변경하는 것 포함. 보통 git pull origin master 라고 씀


### 유의사항
* head : 가 옮길 때마다 스냅샷을 하나씩 찍는다고 생각하면 됨
* Git은 후퇴가 없다 : 고 생각하는 편이 좋음. 히스토리상 reset/revert 하는 게 좋지 않기 때문
* branch : 작업공간이 한 개 더 생긴다고 생각하면 된다. 브랜치를 만든 위치의 파일들이 동일하게 들어있음
* checkout : 가지(branch)를 옮기는 거지, 이전 파일을 복사하는 게 아님!
* conflict : 같은 줄에 다른 내용이 있는 경우에 생기는 문제로, 수동으로 수정해서 저장하면 됨
* reset/revert : 하기 보다는 이전 commit_id에서 가지를 쳐서 수정하는 것이 좋다. ( git branch <브랜치이름> <commit_id>)
* 원격으로 올릴 때 : branch 이름이 같아야 한다. 원격에 해당 브랜치가 없는 경우엔 그냥 올리면 된다.(원격에 자동으로 동일한 이름의 branch가 새로 생성되기 때문)
* 원격과 로컬에 있는 파일 중, 원격 버전이 더 높으면, pull을 통해 로컬의 버전을 맞춘 뒤 push 해야한다.
* .gitignore : add, commit, push 시 무시할 파일. gitignore.io 에서 “swift”, “cocoa pods”, “Xcode” 등을 검색해서 해당 파일을 워크스페이스 폴더에 넣어두면 됨
* Xcode에서 우측상단의 교차 화살표 버튼을 누르면 이전 버전과의 차이점 보여줌

<br/>

## 4. 외부 레파지토리를 제공해주는 서비스업체 : GitHub
### 같은 도메인(깃헙)에 여러 아이디를 쓸 때의 문제
* 상황 : 프로젝트마다 다른 아이디로 로그인해야 하는 경우 (예) 깃헙에 계정이 undervine@naver.com, undervine@gmail.com 등 2개 이상 있는 경우
* 문제 : 한 OSX 로그인 계정에서 다른 깃헙 계정을 쓰게 되면, 패스워드 캐싱이 제대로 작동하지 않음. (예) A프로젝트에서 작업해야 하는데, B프로젝트에서 로그인 했던 인증정보가 캐싱됨
* 해결책1 : OSX의 로그인 계정을 분리해서 쓰는 것이 가장 깔끔함
* 해결책2 : 리모트 저장소 URL에 계정정보를 포함하면 됨
	* 즉, A프로젝트와 B프로젝트의 리모트 저장소 URL 각각에 해당 계정정보를 바인딩하는 방법
	* _git remote -v_ 를 하면 해당 프로젝트와 연결된 깃헙의 url이 나옴
	* _git remote set-url origin https://undervine@github.com/undervine/iOS5.git_ 을 하면 깃헙 연결 시 계정정보를 바인딩할 수 있음
	* _git remote add origin https://github.com/undervine/iOS5.git_ 를 하면, 현재 프로젝트 폴더(A)에 해당 깃헙(undervine)이 연결됨

* 참고 : [터미널에서 git 패스워드 기억하기](https://medium.com/happyprogrammer-in-jeju/mac-os-x-터미널에서-git-패스워드-기억하기-5675d58a60cd)

<br/>

## - 사용한 unix commands
    * mkdir
    * ls -al
    * cd
    * rm -dr
    * cp
    * vi
    * nano


## - 초기 Git 설치 시 사용한 package management : *Homebrew*
    * brew install <package>
    * brew info <package>
    * brew search
    * brew upgrade <package>
    * brew update
    * brew uninstall
    * brew list

<br/><br/>
# 기타
## iOS 개발용어
**스위프트(Swift)란?**
> 

- 소프트웨어 개발 도구(Software Development Kit, 이하 SDK)란?
- Xcode란? Playground란?
- 운영체제(Operating System, 이하 OS)란?
- Hello World 소스 코드 구현 및 실행
- 소스 코드는?
- 컴파일이란? 실행이란?
- 입력이란? 출력이란?


## 깃헙 저장소
- github 저장소
- github이란?
- git이란?
- commit이란?
- push란?
- 기타


## 마크다운
- 위키란?
- markdown의 용도는?
- read.md 파일은?