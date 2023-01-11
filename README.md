# 모각코

### 🌱 모각코, 위치 기반 스터디 메이트 매칭 서비스

- 개발기간 **:** 2022.11.07 ~ 2022.01.11

- SSAC 2기 Service Level Project의 일환으로 1인 iOS 개발
- 1인 iOS 개발 담당 / 기획, 디자인, 서버는 교육과정을 통한 제공
 
- Swagger, Confulence, Figma, Notion, Zep 사용


<br>
<hr>


### 🌱 모각코 화면 및 기능 소개

<br>

|온보딩|초기설정|홈|검색|
|:-:|:-:|:-:|:-:|
|![IMG_5711](https://user-images.githubusercontent.com/63235947/211245384-759c073f-494b-4e46-b85d-de696a4d5749.PNG)|![IMG_5712](https://user-images.githubusercontent.com/63235947/211245394-5f77fc1f-9de9-430f-8aad-d967eb4e0137.PNG)|![IMG_5715](https://user-images.githubusercontent.com/63235947/211245398-074185c0-9c87-4f92-8d5a-778441fc58b9.PNG)|![IMG_5680](https://user-images.githubusercontent.com/63235947/211195473-d896354b-1e4c-4a1a-88f1-abe9894dad82.PNG)|

|요청|수락|채팅|내정보|
|:-:|:-:|:-:|:-:|
|![IMG_5681](https://user-images.githubusercontent.com/63235947/211195477-fefb3b48-1622-46ce-8b94-6c9a096f08a3.PNG)|![IMG_4918](https://user-images.githubusercontent.com/63235947/211245942-333d9ce8-21a6-4d3d-9266-f3480067bb14.PNG)|![IMG_853658CCAC24-1](https://user-images.githubusercontent.com/63235947/211774393-67a26002-e63f-4f6e-b800-ebeed93fab26.jpeg)|![IMG_5717](https://user-images.githubusercontent.com/63235947/211245401-cd7324e5-1530-4625-91bc-f6e10c3b2392.PNG)|

<br>

- 문자인증 기반 회원가입 및 탈퇴

- 실시간 위치 기반 주변 스터디메이트 탐색

- 스터디 기반 스터디메이트 검색 기능

- 스터디메이트 요청/수락 기능

- 일대일 채팅

- 리뷰 남기기

- 내 정보 관리

<br>
<hr>

### 🌱 모각코 기술 스택 소개

<br>

- `RxSwift` `RxCocoa` `MVVM` `MVC`

- `Alamofire+URLRequestConvertible` 
 
- `SnapKit` `Then` `CodeBase`
 
- `Firebase Auth` `FCM`  

- `Realm` 

- `SocketIO` 

- `NMapsMap` 

- `MultiSlider` 


<br>
<hr>

### 🌱 모각코 회고

<br>

> ###  🔺 새롭게 배우고, 좋았던 점 `Keep`
1. 온보딩을 `collectionView + pageControl`로 구현했는데 `Rx+main 프로젝트`가 제법 구글링하기 좋은 프로젝트다!!

<br>
 
2. `scrollViewWillEndDragging`을 알엑스로 구현하기 위한 방법 : `onboardView.collectionView.rx.willEndDragging`
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

<br>
 
3. 온보딩에서 달라지는 라벨과 특정 부분에 색이 적용되는 건 switch문으로 해결했다.
- 라벨로 해야 하는 이유는 **`로컬라이징/보이스오버`** 대응해야 하기 때문이다.

<br>
 
4. `PlainTextField` 만들 때 `clearButtonRect` 메소드 새롭게 적용했다.
`editingDidBegin/editingDidEnd`도 커스텀 텍스트 필드에서 구현해서 적용할 수 있다. 그래서 별도로 `isSelected` 같은 처리를 안해도 된다.

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

<br>
 
5. Rx에서 제공하는 다양하고 새로운 연산자들을 적용해볼 수 있는 경험 획득!
- 1 ) `withLatestFrom` 연산자를 통해서 버튼 탭 시에 각각 isValid 즉, 텍스트필드의 값이 유효한지에 대한 Bool값을 반환하도록 함. 
- 2 ) `compactMap`을 사용해서 coordinate 값을 받아오는 처리를 해줬음. `compactMap`은 1차원 배열에서 옵셔널 바인딩 처리해주는 장점이 있어서 간편함을 느낌.
- 3 ) `throttle` 문자 메시지 인증 코드를 받아 버튼을 누르는 경우 사용자의 과도한 탭을 통해 API 서버 통신이 되는 걸 막기 위해 사용함.
```
output.tap
    .withUnretained(self)
    .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
    .subscribe(onNext: { (vc, isValid) in
        isValid ?
        vc.messageViewModel.requestLogin() :
        vc.showToast(Toast.phoneTypeError.message)
    })
    .disposed(by: disposeBag)
```

<br>
 

6. 선택 시 expandable 되는 화면을 구현하면서 cell에도 마진값을 줄 수 있고, stackView에도 마진값을 줄 수 있다는 사실을 배웠다. (inset)
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

<br>
      

7. 그동안 코드 기반으로 레이아웃을 잡을 때 SnapKit을 자주 사용했는데 새롭게 알게 된 메소드들. 해당 메소드를 통해 채팅뷰에서 입력창 레이아웃과 익스펜더블 UI 등을 구현했다.


  - `priority(.low)` 를 해주면 우선순위를 설정할 수 있다. 
  - `updateConstraints` : 제약 변경 시
  - `remakeConstraints` : 기존 제약이 다 사라지고 다시 설정     

<br>
 
8. `RxCoreLocatio`n을 써보는 것이 안되어 알게 된 `DelegateProxy`를 `extension`으로 넣어 Rx로 CoreLocation 구현했다. 신기한 점은 Rx에서 자체적으로 제공하는 것도 엑코 버전에서는 오류가 발생해서 사용하지 못해서 해당 방법으로 해결했음

<br>
 
9. 브라켓이 있는 배열을 서버 통신 시 body에 담아 보낼 때 **`URLEncoding(arrayEncoding: .noBrackets)`** 을 통해 브라켓을 제거해줄 수 있다는 방법을 알았고, 알라모파이어에서 제공해주는 인코딩 메소드들을 공부하는 계기가 됐다.
<img width="732" alt="스크린샷 2023-01-09 오후 3 11 44" src="https://user-images.githubusercontent.com/63235947/211249635-88e4baae-8852-4dcf-b579-a0661c622e6e.png">

<br>

10. 적절하게 뷰를 커스텀해 필요한 컴포넌트를 사용한 점과, 클래스 내부에 필요한 열거형을 통해 불필요한 코드의 반복을 줄인 점.
- 접근제어자 사용해서 외부에서 접근하지 못하게 막았고, 런타임 시 성능을 높였다.
- ![스크린샷 2023-01-12 오전 12 59 33](https://user-images.githubusercontent.com/63235947/211854540-36aa2850-efd3-4b97-b7a2-ae3840652b8b.png)



<br>
<hr>

> ### 🔻 아쉽고 개선해야 할 점 `Problem & Try`
1. Input/Output 패턴을 공부하고 바로 적용하기에 어느 정도 시간이 걸렸던 점 (초기설정에서 제대로 적용)
- 데이터의 흐름을 파악할 수 있어 좋았지만 후반부에는 공수산정 실패의 원인이 되어 패턴을 사용하지 않게 됐다.

![스크린샷 2023-01-12 오전 12 51 18](https://user-images.githubusercontent.com/63235947/211852427-146bf385-170e-4ba7-97b6-ee2e723db932.png)

<br>
 
2. API 별로 **응답값과 상태코드가 오는 경우** or **상태코드만 오는 경우**가 있는데 하나의 APIManager의 타입 메소드로 관리해주려고 여러번 시도하다보니 딜레이됐다는 점.

```
final class APIManager {
    private init() { }
    static let shared = APIManager()
    
    typealias Completions<T> = ((T?, Int?, APIError?) -> Void)
    
    func request<T: Decodable>(_ type: T.Type = T.self,
                               _ convertible: URLRequestConvertible,
                               completion: @escaping Completions<T>) {
        
        AF.request(convertible)
            .responseDecodable(of: type) { [weak self] response in
                guard let self = self else { return }
                guard let statusCode = response.response?.statusCode else { return }
                completion(nil, statusCode, nil)
                print("⚠️ 상태코드만!!! ===", type, "/", statusCode)
                
                switch response.result {
                case .success(let data):
                    completion(data, statusCode, nil)
                    print("✅ 성공!!! ===", data, "/", statusCode)
                    
                case .failure(_):
                    guard let error = APIError(rawValue: statusCode) else { return }
                    if error.rawValue == 401 {
                        ErrorManager.refreshToken {
                            self.request(type, convertible, completion: completion)
                        }
                    }
                    completion(nil, statusCode, error)
                    print("❌ 실패!!! ===", type, "/", error, "/", error.localizedDescription)
                }
            }
    }
}
```

- 이 경우, 꼭 하나의 메소드를 사용하지 않아도 된다는 것과 추후 Rx에서 제공해주는 Single이라는 옵저버블을 알게 됐는데, success, error 이벤트만 방출해 네트워크에 적합하다고 생각돼서 공부 후 적용해보고 싶다고 생각하게 됐다.

<br>
 
3. 뷰모델에서 네트워크 처리 후 화면전환 처리해줄 때 코디네이터 패턴의 필요성을 느끼게 되었으나, 제한된 시간으로 인해 공부할 시간이 없어 적용하지 못했다.

<br>
 
4. 채팅을 구현할 때 어려웠던 점이 `BehaviorSubject`를 통해 `chatResponse`를 받아서 postChat 서버통신 시 보내는 채팅 데이터를 onNext를 통해 넣고, 뷰에 채팅 내용을 뿌려주는데 이때 채팅 배열이 아닌 보낸 채팅 내용만 하나씩 들어가 어려움을 겪었다. 그래서 `[Chat]` 타입을 가진 chatList를 따로 만들고 이 `chatList`를 `onNext`를 통해 값을 넣어줬다. 이 부분에서 반응형 프로그래밍을 적용함에도 불구하고 불필요한 과정이 중간에 들어간 점이 아쉽고, 개선점을 고민해봐야 할 것 같다.

```
/// ChatViewModel

var chatList = [Chat]()
    
let chatResponse = BehaviorSubject<[Chat]>(value: [])
    
func postChat(_ chat: String, to: String, completion: @escaping ((Int) -> Void)) {
    APIManager.shared.request(Chat.self, ChatRouter.sendChat(chat: chat, to: to)) { [weak self] data, status, error in
        guard let self = self else { return }
        if let data = data {
            self.chatList.append(
                Chat(id: data.id,
                     to: data.to,
                     from: data.from,
                     chat: data.chat,
                     createdAt: data.createdAt.toDate().toString(format: .special)))
            
            RealmRepository.shared.addChatData(
                chat: RealmChat(id: data.id,
                                from: data.from,
                                to: data.to,
                                chat: data.chat,
                                createdAt: data.createdAt.toDate()))
            
            self.chatResponse.onNext(self.chatList)
            completion(self.chatList.count)
        }
        if let error = error {
            ErrorManager.handle(with: error, vc: ChatViewController(ChatViewModel()))
        }
    }
}
```

<br>

5. 검색뷰를 구현 시 복잡한 로직 처리를 설계하는 데에 어려움을 겪었고, 비즈니스 로직을 제대로 뷰모델로 분리시키지 못한 점이 개선할 부분.
 
<br>
<hr>

