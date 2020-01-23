//
//  TranslateResultViewController.swift
//  HiraganaTranslator
//
//  Created by Yohta Watanave on 2020/01/23
//  Copyright © 2020 Yohta Watanave. All rights reserved.
//
import UIKit
import RxSwift
import Swinject

class TranslateResultViewController: UIViewController {

    enum Transition: Equatable {
        case menu
        case dismiss
        case errorAlert(String)
    }

    private let viewModel: TranslateResultViewModel
    private let alertService: AlertService
    private let disposeBag = DisposeBag()
    let transitionDispatcher = PublishSubject<Transition>()

    @IBOutlet weak var backToTopButton: ThemeButton!
    @IBOutlet weak var backButton: ThemeButton!
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(viewModel: TranslateResultViewModel, alertService: AlertService) {
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
        self.backToTopButton.rx.tap
            .bind { [transitionDispatcher] in
                transitionDispatcher.onNext(.menu)
            }
            .disposed(by: self.disposeBag)
        self.backButton.rx.tap
            .bind { [transitionDispatcher] in
                transitionDispatcher.onNext(.dismiss)
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
    func bindIntent(viewModel: TranslateResultViewModel) {
    }

    // MARK: - bind render
    func bindRender(viewModel: TranslateResultViewModel) {
    }

    // MARK: - bind transition
    func bindTransision(transitionDispatcher: PublishSubject<Transition>) {
        transitionDispatcher
            .bind { [weak self] transition in
                guard let self = self else { return }
                switch transition {
                case .menu:
                    // FIXME: NavigationControllerを利用した実装に置き換える
                    guard var viewController = self.presentingViewController else { return }
                    while viewController.presentingViewController != nil {
                        viewController = viewController.presentingViewController!
                    }
                    viewController.dismiss(animated: true, completion: nil)
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
