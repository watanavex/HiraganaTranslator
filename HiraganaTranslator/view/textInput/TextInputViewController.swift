//
//  TextInputViewController.swift
//  HiraganaTranslator
//
//  Created by susan on 2020/01/23
//  Copyright © 2020 Yohta Watanave. All rights reserved.
//
import UIKit
import RxSwift
import Swinject

class TextInputViewController: UIViewController {

    enum Transition: Equatable {
        case translateResult
        case dismiss
        case errorAlert(String)
    }

    private let viewModel: TextInputViewModel
    private let alertService: AlertService
    private let disposeBag = DisposeBag()
    let transitionDispatcher = PublishSubject<Transition>()

    @IBOutlet weak var backButton: ThemeButton!
    @IBOutlet weak var translateButton: ThemeButton!
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(viewModel: TextInputViewModel, alertService: AlertService) {
        self.viewModel = viewModel
        self.alertService = alertService
        
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .fullScreen
        self.modalTransitionStyle = .flipHorizontal
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
        self.backButton.rx.tap
            .bind { [transitionDispatcher] in
                transitionDispatcher.onNext(.dismiss)
            }
            .disposed(by: self.disposeBag)
        self.translateButton.rx.tap
            .bind { [transitionDispatcher] in
                transitionDispatcher.onNext(.translateResult)
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
    func bindIntent(viewModel: TextInputViewModel) {
    }

    // MARK: - bind render
    func bindRender(viewModel: TextInputViewModel) {
    }

    // MARK: - bind transition
    func bindTransision(transitionDispatcher: PublishSubject<Transition>) {
        transitionDispatcher
            .bind { [weak self] transition in
                guard let self = self else { return }
                switch transition {
                case .translateResult:
                    let viewController = sharedTranslateResultContainer.resolve(TranslateResultViewController.self)!
                    self.present(viewController, animated: true, completion: nil)
                case .dismiss:
                    self.dismiss(animated: true, completion: nil)
                case .errorAlert(let errorMessage):
                    self.alertService.present(viewController: self,
                                              message: errorMessage,
                                              actions: [CloseAlertAction()])
                        .subscribe()
                        .disposed(by: self.disposeBag)
                }
            }
            .disposed(by: self.disposeBag)
    }
}
