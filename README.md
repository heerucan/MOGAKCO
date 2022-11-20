# SSAC-Mogakco-SLP
#### 🌱 SSAC : Service Level Project - SSAC 모각코
 
### 🦋 개발일지 🦋

## 11/7 (1주차 시작)
> 오늘의 개발
- 프로젝트 초기 세팅 및 디자인시스테 구축
- PlainButton 재사용 가능하게 구현
- 스플래시 / 온보딩 구현
- 인증뷰에 재사용되는 ReuseView 구현

> 좋았던 점
- 온보딩을 collectionView + pageControl로 구현했는데 Rx+main 프로젝트가 제법 구글링하기 좋은 프로젝트다
- scrollViewWillEndDragging을 알엑스로 구현하기 위한 방법 : onboardView.collectionView.rx.willEndDragging
```
onboardView.collectionView.rx.willEndDragging
            .withUnretained(self)
            .subscribe(onNext: { (vc, arg1) in
                let (_, targetContentOffset) = arg1
                let page = Int(targetContentOffset.pointee.x / self.onboardView.collectionView.frame.width)
                self.onboardView.pageControl.currentPage = page
            })
            .disposed(by: disposeBag)
```
- 온보딩에서 달라지는 라벨과 특정 부분에 색이 적용되는 건 switch문으로 해결 >> 라벨로 해야 하는 이유는 로컬라이징/보이스오버 대응해야 하기 때문

## 11/8
- 위클리 발표 준비로 인해 off

## 11/9
> 오늘의 개발
- 인증 부분 전반적인 뷰 짜기
- 전반적인 로직 구현 (유효성 검증/정규식 등 로직처리 mvvm+rx)
- PlainTextField 구현

> 좋았던 점
- 텍스트필드, 버튼, 그리고 인증에 사용되는 재사용뷰를 미리 만들어둬서 그리고 제법 초반에 귀찮았지만 디테일하게 고려해서 만들어서 뷰를 구현하는 건 되게 빠르고 쉽게 할 수 있었다.
- PlainTextField 만들 때 clearButtonRect 메소드 새롭게 적용
  - editingDidBegin/editingDidEnd도 커스텀 텍스트 필드에서 구현해서 적용할 수 있다. 그래서 별도록 isSelected 같은 처리를 안해도 됨

```
    private func setupState() {
        self.addTarget(self, action: #selector(editingDidBegin), for: .editingDidBegin)
        self.addTarget(self, action: #selector(editingDidEnd), for: .editingDidEnd)
    }
}

// MARK: - TextField State

extension PlainTextField {
    @objc func editingDidBegin() {
        lineView.backgroundColor = Color.black
    }
    
    @objc func editingDidEnd() {
        lineView.backgroundColor = Color.gray3
        self.resignFirstResponder()
    }
}

```
> 어려운 점
- 어려운 건 성별 여/남 선택 부분을 컴포지셔널+디퍼블을 써서 구현했는데 itemSelected에서 어떻게 접근해야 하는지 모르겠어서 머리를 뽑을 뻔 하다가 cell에 접근하는 방식으로 구현했다.
생각해보니 꼭 컬렉션뷰로 만들지 않아도 되긴 했다.

```
        output.genderIndex
            .withUnretained(self)
            .bind { (vc, indexPath) in
                guard let cell = vc.genderView.collectionView.cellForItem(at: indexPath) as? GenderCollectionViewCell
                else { return }
                vc.genderView.reuseView.okButton.isEnable = cell.isSelected ? true : false
                cell.isSelected.toggle()
            }
            .disposed(by: disposeBag)
```

- 어려운 점은 Input/Output 개념이 갑자기 흔들려서 구글링하고 찾아봐도 아무리 이해가 안가서 멘붕이 와버린 점, 그래서 우선 패턴 빼두고 구현해둔 상태


## 11/10
> 오늘의 개발
- 위클리 발표 준비
- Input/Output 전체 로직 리팩토링 (황호좌한테 설명 듣고 개념 머리에 다시 박았따!)
- BirthView 구현 고민
- 파베 연결 및 문자 인증 적용해서 성공 (생각보다 한방에 돼서 깜짝!)
> 좋았던 점
- 큰맘 먹고 오픈캠퍼스 가서 Input/Output 설명 듣고 이해한 것
- 사용자의 입력 값들을 뷰모델의 Input으로 받아서 해당 값을 다시 Output으로 내보내서 뷰에 전달해야 하는데 그 과정에서 필요한 로직처리를 뷰모델의 transform 메소드에서 해준다.
- BirthView에서 처음부터 데이트피커의 초기값이 들어가서 Placeholder가 적용이 안되는데 skip 연산자로 해결 (방출된 이벤트를 설정한 개수만큼 초반에 무시해줌)

> 어려운 점
- 파베 문자 인증 부분에서 반응형으로 대응해주다보니 텍스트필드에 값을 입력할 때마다 문자 받는 함수가 실행돼서 throttle, debounce 처리를 해줘야 할 것 같다.
  - throttle : 지정해준 몇 초 동안 가장 처음 값을 하나 방출 - 주로 네트워크에 사용
  - debounce : 지정해준 몇 초 동안 가장 최신 값 하나 방출 - 주로 연관검색어

## 11/11

> 오늘의 개발
- UserDefaults를 Property Wrapper로 관리하게 분리 (어떻게 사용하는지 모름..)
- ATS ExceptionDomain을 통해서 싹 도메인 제외 (http)
- idToken 받아서 파베에 가입한 사용자인지 식별하는 과정 처리
- 토큰 개념 머리에 재정립 - 언제 갱신해줘야 하는지!

## 11/12
> 오늘의 개발
- 좋은 서버 통신 코드를 위한 삽질 끝에 결국 제자리로...
- 에러 분기처리
- 서버 통신을 위한 초기 세팅
> 어려운 점
- 서버 통신할 때 네트워크 통신 코드를 현재 Alamofire + URLRequestConvertible로 처리해주고 있는데 여기서 옵저버블로 데이터 모델을 감싼 값을 반환 받아서 뷰모델에서 처리하고 싶었는데 아무리 해도 안돼서 우선,, 기존 코드로 뷰컨에서 구현하게 됐다.
- 어떻게 해야 네트워크 로직 코드가 뷰모델에 들어가지?
- 화면전환은 어떻게 뷰모델에서 처리해주지..? 이럴 때 코디네이터 패턴이 필요한가?

## 11/13
> 오늘의 개발
- 사용자 초기/신규인지에 따라 첫 시작 화면 분기처리
- 기존 문자 인증을 통해 파베 로긘하는 코드 리팩토링
- 로그인/회원가입/탈퇴 서버 통신 마무리
- 토큰 갱신 코드 파베에서 제공하는 걸로 401 뜰 때 처리
- 상태코드마다 핸들링을 다르게 해주기 위해서 해당 부분을 extension에 함수로 만들어서 상태코드 파라미터로 받아서 넣는 방식으로 해줬다.
- toastMessage도 마찬가지로 LocalizedError 프로토콜을 통해서 케이스마다 errorDescription 써준 대로 띄워지게 했음
- 탭바 추가
```
    func handle(with error: APIError) {
        
        switch error {
        case .success:
            print(error.rawValue, error.errorDescription!)
            
        case .nicknameError:
            print(error.rawValue, error.errorDescription!)
            // TODO: - 리팩토링 시급한 부분
            let viewControllers: [UIViewController] = (self.navigationController?.viewControllers) as! [UIViewController]
            self.navigationController!.popToViewController(viewControllers[viewControllers.count - 4], animated: true)
            viewControllers[viewControllers.count - 4].showToast(ToastMatrix.invalidNickname.description)
            
        case .expiredTokenError:
            print(error.rawValue, error.errorDescription!)
            self.refreshToken()
            self.showToast(ToastMatrix.overRequestError.description)
            
        case .notCurrentUserError:
            print(error.rawValue, error.errorDescription!)
            let vc = NicknameViewController()
            self.transition(vc, .push)
            
        default:
            print(error.rawValue, error.errorDescription!)
        }
    }
```

> 좋았던 점
- withLatestFrom 연산자를 통해서 버튼 탭 시에 각각 isValid 즉, 텍스트필드의 값이 유효한지에 대한 Bool값을 반환하도록 했음
> 어려운 점
- 네트워크 연결 상태에 따라 처리해주기 위해서 NetworkMonitor를 달아줬는데 왜 셀룰러가 끊기면 강종이 되는 걸까?
- UserDefaults를 Property Wrapper를 공부하지 않은 상태에서 적용하다보니 어려워서 그냥 싱글톤으로 처리하게 변경
- 반환값이 상태코드로 Int만 존재할 때 값이 안나와서 애를 먹는 중.. 그래서 GenericAPI 함수가 2개가 됐다. 이걸 해결해줘야 한다!! 지금 너무 더러운 코드임.ㅠ

## 11/14 (2주차 시작)
> 오늘의 개발
- 내 정보 구현! 초반에 구조 고민을 열심히 하다가 expandable로 하려고 했는데 그러면 border가 안생겨서 구조를 중간에 바꿨다. 삽질은 덜했는데 완벽한 구현이 안돼서 조금 고민...

> 좋았던 점

> 어려운 점
- 셀이 내려갔다 스무스하게 올라오지 않는 중이라 애먹고, 우울함.. 이거 해결해!내!자!
- 스택뷰 레이아웃 잡는 게 생각보다 맘대로 되지 않아서 레이아웃에서 삽질 중
- 스냅킷 오류 완전 많이 떠;;;;
- 하단 info 부분은 셀 하나로 재사용하려고 했는데 그랬더니 재사용 이슈가 생겨서 회원탈퇴가 내 번호 검색 허용으로 겹쳐버림
- 스택뷰 bottom을 셀에서 잡아주지 않으면 셀 높이를 알지 못하는 이슈가, 셀에 잡아주면 하단 부분이 이상해짐 what should i do?


## 11/15
> 오늘의 개발
- 내 정보 관리 Layout 각잡고 개선 (해냅니다...!?)
- 전체를 테이블뷰로 잡고, 테이블뷰에 섹션을 하나 주고, 상단 이미지는 sectionHeader로, 
접히는 카드 부분은 0번째 Cell, 하단 데이터는 1번째 Cell로 구현
- 카드 셀 내에서는 전체 stackview에 nameView + titleView + reviewView로 해서 constraint 잡았다. 왜 뷰로 나눴나? 스택뷰로 나눠도 됐을텐데... 여튼, 재사용되는 곳이 있어서 그렇게 처리함
- MultiSlider SPM 추가해서 슬라이더 적용
- 홈 지도를 위한 Naver Map 추가
> 좋았던 점
- 결국 다 뜯어고쳤지만 성공해냈다!
- 혼자 해내죠?!
- 스냅킷 이슈가 와방하게 떴는데 결국 다 해결했다. 원인은 PlainButton의 높이를 내가 재사용으로 만들면서 42로 고정값을 줘서 잡았는데 생각해보니 38인 것도 있어서 height를 다시 세팅해서 생긴 이슈가 대다수였다.
- cell에도 마진값을 줄 수 있고, stackView에도 마진값을 줄 수 있다. (inset)

```
$0.layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
            $0.isLayoutMarginsRelativeArrangement = true
```
```
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 16, bottom: 16, right: 16))
    }
```

- 새롭게 알게 된 스냅킷
  - priority(.low) 를 해주면 우선순위를 설정할 수 있다. 
  - updateConstraints : 제약 변경 시
  - remakeConstraints : 기존 제약이 다 사라지고 다시 설정
> 어려운 점
- 생각보다 레이아웃 어렵다..


## 11/16
> 오늘의 개발
- 너무 쉬고 싶어서 휴식을 취했다.
> 좋았던 점
- 몸이 개운한 것이 이것이 인생인가 싶었다.
> 어려운 점
- 내일의 내가 걱정이다...

## 11/17
> 오늘의 개발
- 홈 뷰 화면 구현
- Rx+MVVM으로 CoreLocation을 통해 사용자 위치 권한 로직 처리
- LocationManager 싱글톤 클래스로 관리
> 좋았던 점
- RxCoreLocation을 써보는 것이 안돼서 소깡이에게 알게 된 DelegateProxy를 긁어다가 extension으로 넣어서 Rx로 CoreLocation 구현했다. 신기한 점은 Rx에서 자체적으로 제공하는 것도 내 엑코 버전에서는 오류가 발생해서 사용하지 못해서 이렇게 해결했음
- compactMap을 사용해서 coordinate 값을 받아오는 처리를 해줬음. compactMap은 1차원 배열에서 옵셔널 바인딩 처리해주는 장점이 있어서 간편하다.
- behaviorSubject.onNext(~)는 새로운 값을 추가해주는 거다! 기억!
> 어려운 점
- RxCoreLocation을 써보려고 했는데 iOS11.0 이상에서는 Rx.. keypath 부분 사용에 오류가 발생한다는 이상한 오류가 발생해서 삽질하다가 소깡, 희철님한테 도움을 받았는데 알고보니 엑코 버전 때문에 생기는 문제였다.
덕분에 시간 와방하게 날림

## 11/18
> 오늘의 개발
- 홈 내 주변 새싹 / 내 현재 상태 서버 통신
- 홈 기능 다수 구현(마커 꽂기, 현재 상태 체크 등)
> 좋았던 점
- 기획명세서를 항상 자세하게 읽자! 현재 상태 통신하면서 응답값 중 초기에 값이 안들어오는 애가 있는데 그냥 응답값 긁어다가 구조체로 변환해서 넣어줬는데 아무리 해도 decodingError가 뜨길래 명세서 다시 보고 알게 됐다. decodeIfPresent로 처리했다.
> 어려운 점
- 한걸음 한걸음이 어려운 것 투성이라.. 기억이 안남.

## 11/19
> 오늘의 개발
- 네트워크 코드 리팩토링
- 홈 뷰 기능 input/output 패턴으로 리팩토링
- 커스텀 네비게이션바에 backButton 기능 구현
- 네비바/버튼/auth 재사용 뷰에서 발생하는 스냅킷 오류 잡기
- 내 주변 새싹 찾기 뷰 초기 세팅 : 상단 커스텀 탭바와 엠티뷰, 테이블뷰 세팅
- 내 주변 새싹 찾기 뷰를 위한 PlainSegmentedControl, EmptyStateView 재사용으로 분리해서 구현
> 좋았던 점
- 사실 이게 맞는 방식인지 모르겠으나, 기존에 VC에서 처리하던 네트워크 코드를 VM로 옮겼다. 그리고 응답값들이 있는 경우에 PublishSubject를 통해서 VM로 받아서 output을 거쳐서 VC에서 처리한다. 이게 맞는 방식인지 잘 모르겠지만 그래도 네트워크 코드 및 로직 처리 코드가 VC에서 사라져서 맘이 한결 가볍군...
- 커스텀 네비바를 만들었으니 backButton도 커스텀 내에서 동작되도록 구현하는 법을 찾아보다가 UIButton에서 addTarget 이외에 addAction(UIAlertVC에서 액션 주는 것처럼)을 통해서도 할 수 있단 걸 알았다. UIAction은 클로저를 통해서 기능을 구현할 수 있는데 덕분에 코드가 줄었다.
```
    var viewController: UIViewController?
    
    private lazy var backAction = UIAction { _ in
        self.viewController?.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Initializer
    
    init(type: NavigationType) {
        super.init(frame: .zero)
        titleLabel.text = type.title
        leftButton.addAction(backAction, for: .touchUpInside)
```
- 커스텀 탭바에서 line을 어떻게 이동시킬까 고민했는데 UIView.animate를 통해서 lineView의 leading값을 transform을 통해 변경할 수 있게 했다. leading값에는 (세그먼트 컨트롤의 width / 현재 세그먼트의 인덱스)로 값을 넣었다.
```
    private func changeLinePosition() {
        let segmentIndex = CGFloat(segmentedControl.selectedSegmentIndex)
        let segmentWidth = segmentedControl.frame.width / 2
        let leadingDistance = segmentWidth * segmentIndex
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            guard let self = self else { return }
            self.lineView.transform = CGAffineTransform(translationX: leadingDistance, y: 0)
        })
    }
```
- 별개로 스냅킷 오류 잡기 재밌네...
> 어려운 점
- myQueueState에서 201 응답값이 안넘어와서 서버 코드 리팩을 했다.(사실 여전히 마음에 들지 않는다.)
디코딩해줄 데이터가 없어서 ResultType에서 success 시에도 데이터가 nil로 넘어오는 경우가 있는데 그게 myQueueState에서 201인 경우다. 근데 그걸 캐치하지 못하고 조금 삽질을 와방하게 하다가 success/failure이 아닐 때 completion(nil, status, nil)을 넘겨주면 된다는 걸 깨달았다.
해당 방법 말고도, alamofire에서 responseDecodable 대신에 responseData를 사용해서 디코딩해 줄 데이터가 있다면 JSONDecoder를, 없으면 그냥 위와 같이 completion을 넘겨주는 방식도 가능하다.
그나저나 삽질하다가 네트워크 코드만 몇 번이나 갈아엎는 건지... 에효ㅠ 여전히 맘에 안든다.. 그동안 Moya만 써와서 이번에는 Alamofire+URLRequestConvertible로 쓰고 싶었는데 아직 개념이 덜 들어왔는갑다.. 으악!

## 11/20
> 오늘의 개발

> 좋았던 점

> 어려운 점







