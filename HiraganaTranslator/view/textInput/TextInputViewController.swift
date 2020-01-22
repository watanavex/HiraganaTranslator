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

    enum Transition {
        case errorAlert(String)
    }

    private let viewModel: TextInputViewModel
    private let alertService: AlertService
    private let disposeBag = DisposeBag()
    let transitionDispatcher = PublishSubject<Transition>()

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
