//
//  BottomCardView.swift
//  jeolhak
//
//  Created by 윤대현 on 3/28/25.
//

/**
 하단 카드뷰 설정
 */
/** 하단 카드 뷰 생성 클래스  */
import UIKit

class BottomCardView: UIView {
    
    private let tableView = UITableView()
    
    // 가게 정보
    private var stores: [Store] = []
    // private var homeShopData: [HomeShopData] = []
    
    // 닫힌 상태의 카드 뷰 최소 높이
    private var minCardViewHeight: CGFloat!
    // 열린 상태의 카드 뷰 최대 높이
    private var maxCardViewHeight: CGFloat = 100
    private var topConstraint: NSLayoutConstraint!
    
    private var backgroundView: UIView!
    private unowned let parentView: UIView
    
    // 어떤 뷰에서 카드뷰 호출인지 확인
    // true : HomeView에서 호출, false : FavoriteView에서 호출
    private var isHomeViewCheck: Bool
    
    // store 목록 백업
    private var originalStores: [Store] = []
    
    // 외부에서 정의 가능한 콜백 함수 정의
    // BottomCardView 안에서 제스처가 발생했을 때 외부에 알리기 위한 이벤트 트리거
    // (() -> Void)? : 아무 인자도 받지 않고, 아무것도 반환하지 않는 클로저 타입 (옵셔널)
    var onPanChanged: (() -> Void)?
    
    // 커스텀 이니셜라이저
    init(parentView: UIView, height: CGFloat, isHomeViewCheck: Bool) {
        // 인자로 받아온 부모 뷰를 활용
        self.parentView = parentView
        self.minCardViewHeight = height
        self.isHomeViewCheck = isHomeViewCheck
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        setupBackgroundView()
        setupBottomCardView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /** 카드 뷰가 올라올 때 부모 뷰 블랙 */
    private func setupBackgroundView() {
        backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.0)
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.isUserInteractionEnabled = false
        
        parentView.addSubview(backgroundView)
        
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: parentView.topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: parentView.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: parentView.trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: parentView.bottomAnchor)
        ])
    }
    
    /** 카드 뷰 설정 함수 */
    private func setupBottomCardView() {
        backgroundColor = .white
        layer.cornerRadius = 20
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        // 해당 함수가 실행중인 클래스 인스턴스 자체를 부모 뷰에 추가 : self
        parentView.addSubview(self)
        
        // Handler
        let handle = UIView()
        handle.backgroundColor = .systemGray4
        handle.layer.cornerRadius = 3
        handle.translatesAutoresizingMaskIntoConstraints = false
        addSubview(handle)
        
        NSLayoutConstraint.activate([
            handle.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            handle.centerXAnchor.constraint(equalTo: centerXAnchor),
            handle.widthAnchor.constraint(equalToConstant: 40),
            handle.heightAnchor.constraint(equalToConstant: 5)
        ])
        
        // HomeVC에서 호출했을 때
        if isHomeViewCheck {
            tableView.translatesAutoresizingMaskIntoConstraints = false
            tableView.backgroundColor = .white
            tableView.separatorStyle = .none
            tableView.showsVerticalScrollIndicator = false
            tableView.dataSource = self
            tableView.delegate = self
            tableView.register(HomeContentTableViewCell.self, forCellReuseIdentifier: HomeContentTableViewCell.identifier)
            
            addSubview(tableView)
            
            NSLayoutConstraint.activate([
                tableView.topAnchor.constraint(equalTo: handle.bottomAnchor, constant: 12),
                tableView.leadingAnchor.constraint(equalTo: parentView.leadingAnchor, constant: 20),
                tableView.trailingAnchor.constraint(equalTo: parentView.trailingAnchor, constant: -20),
                tableView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -safeAreaInset())
            ])
            // FavoriteVC에서 호출했을 떄
        } else {
            //            let favoriteTestView = FavoriteContentItemView(
            //                shopTitle: "GT커피 모현점",
            //                shopCategory: "디저트",
            //                shopLocation: "익산시 서동로 18길 42",
            //                shopImage: "testImage",
            //                shopFavorite: false
            //            )
            //
            //            addSubview(favoriteTestView)
            //
            //            NSLayoutConstraint.activate([
            //                favoriteTestView.topAnchor.constraint(equalTo: handle.topAnchor, constant: 15),
            //                favoriteTestView.leadingAnchor.constraint(equalTo: parentView.leadingAnchor, constant: 20),
            //                favoriteTestView.trailingAnchor.constraint(equalTo: parentView.trailingAnchor, constant: -20)
            //            ])
        }
        
        topConstraint = topAnchor.constraint(equalTo: parentView.topAnchor, constant: parentView.frame.height - minCardViewHeight)
        
        NSLayoutConstraint.activate([
            topConstraint,
            leadingAnchor.constraint(equalTo: parentView.leadingAnchor),
            trailingAnchor.constraint(equalTo: parentView.trailingAnchor),
            bottomAnchor.constraint(equalTo: parentView.bottomAnchor, constant: -safeAreaInset()),
        ])
        
        // UIPanGestureRecognizer : 드래그(pan) 제스처 감지
        // target: self -> 제스처가 발생하고 있는 클래스 인스턴스
        // action: #selector(handlePan(_:)) -> 해당 클래스 인스턴스에 존재하는
        // handlePan(_:) 메서드 호출
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        addGestureRecognizer(panGesture)
    }
    
    private func safeAreaInset() -> CGFloat {
        if #available(iOS 11.0, *) {
            return parentView.safeAreaInsets.bottom
        }
        return 0
    }
    
    /** 드래그(팬, 제스쳐)  컨트롤 함수 */
    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
        // 사용자가 얼마나 움직였는지 좌표로 반환
        // 예 : 아래로 50pt 움직였으면 CGPoint(x: 0, y: 50) 반환
        let translation = gesture.translation(in: parentView)
        // 사용자가 움직인 속도를 반환
        // 예 : 해당 반환값을 바탕으로 위로 쓸었는지, 아래로 쓸었는지 판단 가능
        let velocity = gesture.velocity(in: parentView)
        
        // 카드뷰가 최소한으로 내려갔을 때 Y값
        let collapsedTop = parentView.frame.height - minCardViewHeight
        // 카드뷰가 최대로 올라갔을 때 위치
        let expandedTop = maxCardViewHeight
        
        // 현재 카드뷰의 Y 위치와 드래그로 얼마나 움직였는지 감지
        let newTop = topConstraint.constant + translation.y
        
        switch gesture.state {
            // 드래그중일때
        case .changed:
            // newTop : 현재 카드뷰의 위치
            if newTop >= expandedTop && newTop <= collapsedTop {
                // 현재 카드뷰가 상하 한계 범위에 있으면 카드뷰 이동
                topConstraint.constant = newTop
                print("현재 카드뷰 위치(newTop) : \(newTop)")
                print("현재 카드뷰 좌표(translation) : \(translation)")
                /*
                 
                 현재 카드뷰 위치(newTop) : 480.7681884765625
                 현재 카드뷰 좌표(translation) : (0.0, -0.2340087890625)
                 */
                updateBackgroundOpacity()
                // 다음 제스쳐를 계산하기 위해 움직인 값 초기화
                gesture.setTranslation(.zero, in: parentView)
                // 클로저 호출 (부모뷰에게 제스처중임을 알리기)
                onPanChanged?()
            }
            // 드래그가 끝났을 때
        case .ended:
            // 손가락을 위로 쓸었으면(true) 카드뷰를 위로 올리기
            // 손가락을 아래로 쓸었으면(false) 카드뷰를 아래로 내리기
            let shouldExpand = velocity.y < 0
            // 애니메이션 진행
            animate(expand: shouldExpand)
        default:
            break
        }
    }
    
    /** 카드 뷰 애니메이션 컨트롤
     true: 카드뷰 열린상태
     false : 카드뷰 닫힌 상태
     */
    private func animate(expand: Bool) {
        // 카드뷰가 열려있다면(true) 완전히 펼친 위치로 이동
        // 카드뷰가 닫혀있다면(false) 닫힌 상태로 이동
        let targetTop = expand ? maxCardViewHeight : parentView.frame.height - minCardViewHeight
        // 카드뷰 위치 업데이트
        topConstraint.constant = targetTop
        
        // 애니메이션 시작
        // withDuration: 0.3 -> 애니메이션 지속 시간
        // delay: 0 -> 지연시간 없음
        // options: [.curveEaseOut] : 느리게 멈추기
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseOut], animations: {
            // 바뀐 제약조건을 즉시 반영하여 카드뷰가 부드럽게 이동하도록 유도
            self.parentView.layoutIfNeeded()
            self.updateBackgroundOpacity()
        }, completion: { _ in
            // 카드뷰가 닫힐 떄 원본 데이터 복구
            if !expand {
                self.restoreOriginalStores()
            }
        })
    }
    
    /** 카드 뷰를 사용하는 부모 뷰의 배경색 변경 */
    private func updateBackgroundOpacity() {
        let currentTop = topConstraint.constant
        let collapsedTop = parentView.frame.height - minCardViewHeight
        let expandedTop = maxCardViewHeight
        
        let ratio = 1 - ((currentTop - expandedTop) / (collapsedTop - expandedTop))
        backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.3 * ratio)
    }
    
    // 퍼블릭 인터페이스 : 외부에서 BottomCardView 상태 제어
    /** 카드뷰가 최대로 올라갈 수 있는 위치 설정
     ex) bottomCardView.configureExpandedTop(searchBarContainer.frame.maxY + 20)
     */
    func setMaxCardHight(_ yValue: CGFloat) {
        maxCardViewHeight = yValue
    }
    
    /** 카드 뷰 위치 초기화 -> 접혀 있는 상태로 카드뷰 강제 이동 */
    func closeCardView() {
        let collapsedTop = parentView.frame.height - minCardViewHeight
        topConstraint.constant = collapsedTop
        parentView.layoutIfNeeded()
        
        // 본래 가게 목록으로 변경
        restoreOriginalStores()
    }
    
    /** 백그라운드 초기화 */
    func resetBackgroundColor(){
        backgroundView.backgroundColor = .clear
    }
    
    // 데이터 주입
    func updateStores(_ newStores: [Store], keepOriginal: Bool = false) {
        if keepOriginal && originalStores.isEmpty {
            originalStores = stores
        }
        
        self.stores = newStores
        tableView.reloadData()
        
        if stores.isEmpty {
            let emptyView = UIView(frame: tableView.bounds)
            
            let label = UILabel()
            label.text = "할인되는 가게가 없어요..ㅠㅠ"
            label.font = UIFont(name: "Jua-Regular", size: 21)
            label.textColor = .darkGray
            label.translatesAutoresizingMaskIntoConstraints = false
            
            let imageView = UIImageView()
            let config = UIImage.SymbolConfiguration(pointSize: 21, weight: .regular)
            imageView.image = UIImage(systemName: "cloud.rain.fill", withConfiguration: config)
            imageView.tintColor = .mainPink
            imageView.translatesAutoresizingMaskIntoConstraints = false
            
            emptyView.addSubview(label)
            emptyView.addSubview(imageView)
            
            NSLayoutConstraint.activate([
                label.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor, constant: -15),
                label.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor),
                imageView.leadingAnchor.constraint(equalTo: label.trailingAnchor, constant: 8),
                imageView.centerYAnchor.constraint(equalTo: label.centerYAnchor)
            ])
            
            tableView.backgroundView = emptyView
        } else {
            tableView.backgroundView = nil
        }
    }
}

// MARK: - 카드뷰 확장 (DataSource, Delegate 설정)
extension BottomCardView: UITableViewDataSource, UITableViewDelegate {
    
    // 셀 개수 지정
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stores.count
    }
    
    // 표시 내용
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeContentTableViewCell.identifier, for: indexPath) as? HomeContentTableViewCell else {
            return UITableViewCell()
        }
        
        let store = stores[indexPath.row]
        let descriptionText = (store.description?.isEmpty ?? true) ? "할인 내용이 들어갑니다." : store.description!
        cell.configure(
            shopImage: store.imageURL,
            shopTitle: store.name,
            shopCategory: store.category ?? "기타",
            shopContent: descriptionText,
            shopFavorite: false
        )
        
        return cell
    }
}

// MARK: - 마커 클릭 카드뷰 특정 위치까지 올리기 (Y = 480)
extension BottomCardView {
    
    // 마커 클릭 시 Y좌표 480까지 카드 뷰 올리기
    func showCardForMarker(targetTop: CGFloat = 480, selectedStore: Store? = nil) {
        // 목표 위치가 허용 범위 내에 있는지 확인
        let safeTargetTop = max(maxCardViewHeight, min(targetTop, parentView.frame.height - minCardViewHeight))
        
        // 선택된 Store가 있다면 해당 Store만 표시하도록 데이터 업데이트 (원본 데이터는 보관, true)
        if let store = selectedStore {
            updateStores([store], keepOriginal: true)
        }
        
        // 카드뷰 위치 업데이트
        topConstraint.constant = safeTargetTop
        
        // 애니메이션 실행
        UIView.animate(
            withDuration: 0.5,
            delay: 0,
            usingSpringWithDamping: 0.9,
            initialSpringVelocity: 0.2,
            options: [.curveEaseOut],
            animations: {
                self.parentView.layoutIfNeeded()
                self.updateBackgroundOpacity()
            },
            completion: { _ in
                // 애니메이션 완료 후 콜백 호출
                self.onPanChanged?()
            }
        )
    }
    
    // 마커 클릭 시 단일 Store 정보 출력
    func showSelectedStore(_ store: Store, targetTop: CGFloat = 480) {
        showCardForMarker(targetTop: targetTop, selectedStore: store)
    }
    
    // 본래 가게 데이터 출력 (원상복구)
    func restoreOriginalStores() {
        if !originalStores.isEmpty {
            updateStores(originalStores)
            // originalStores.removeAll()
        }
    }
}
