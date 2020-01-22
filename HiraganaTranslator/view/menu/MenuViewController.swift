//
//  MenuViewController.swift
//  HiraganaTranslator
//
//  Created by susan on 2020/01/22
//  Copyright © 2020 Yohta Watanave. All rights reserved.
//
import UIKit
import RxSwift
import Swinject

class MenuViewController: UIViewController {

    enum Transition {
        case camera
        case textInput
    }

    private let viewModel: MenuViewModel
    private let alertService: AlertService
    private let disposeBag = DisposeBag()
    let transitionDispatcher = PublishSubject<Transition>()

    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var clipboardButton: UIButton!
    @IBOutlet weak var keyboardButton: UIButton!
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(viewModel: MenuViewModel, alertService: AlertService) {
        self.viewModel = viewModel
        self.alertService = alertService
            
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupView()
        self.bindRender(viewModel: self.viewModel)
        self.bindTransision(transitionDispatcher: self.transitionDispatcher)
        self.bindIntent(viewModel: self.viewModel)
    }

    // MARK: - setup view
    func setupView() {
        self.cameraButton.rx.tap
            .bind { [transitionDispatcher] in
                transitionDispatcher.onNext(.camera)
            }
            .disposed(by: self.disposeBag)
        self.clipboardButton.rx.tap
            .bind { [transitionDispatcher] in
                transitionDispatcher.onNext(.textInput)
            }
            .disposed(by: self.disposeBag)
        self.keyboardButton.rx.tap
            .bind { [transitionDispatcher] in
                transitionDispatcher.onNext(.textInput)
            }
            .disposed(by: self.disposeBag)
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.setSkyGradientColor()
        self.view.layer.insertSublayer(gradientLayer, at: 0)
        self.rx.methodInvoked(#selector(UIViewController.viewDidLayoutSubviews))
            .bind { [view] _ in
                guard let view = view else { return }
                gradientLayer.frame = view.bounds
            }
            .disposed(by: self.disposeBag)
    }

    // MARK: - bind intent
    func bindIntent(viewModel: MenuViewModel) {
    }

    // MARK: - bind render
    func bindRender(viewModel: MenuViewModel) {
    }

    // MARK: - bind transition
    func bindTransision(transitionDispatcher: PublishSubject<Transition>) {
        transitionDispatcher
            .bind { transition in
                switch transition {
                case .camera:
                    break // TODO: 画面遷移を実装する
                case .textInput:
                    let viewController = sharedTextInputContainer.resolve(TextInputViewController.self)!
                    self.present(viewController, animated: true, completion: nil)
                }
            }
            .disposed(by: self.disposeBag)
    }
}
