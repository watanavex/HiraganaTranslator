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
        case translateResult(TranslateResult)
        case dismiss
        case errorAlert(String)
    }

    private let viewModel: TextInputViewModel
    private let alertService: AlertService
    private let disposeBag = DisposeBag()
    let transitionDispatcher = PublishSubject<Transition>()

    @IBOutlet weak var backButton: ThemeButton!
    @IBOutlet weak var translateButton: ThemeButton!
    @IBOutlet weak var textView: RoundTextView!
    var loadingView: LoadingView!
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(viewModel: TextInputViewModel, alertService: AlertService) {
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
        self.loadingView = LoadingView()
        self.view.addSubview(self.loadingView)
        self.loadingView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        self.loadingView.isHidden = true
        
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
    func bindIntent(viewModel: TextInputViewModel) {
        self.translateButton.rx.tap
            .bind { [textView] in
                guard let textView = textView else { return }
                viewModel.translate(sentence: textView.text)
            }
            .disposed(by: self.disposeBag)
    }

    // MARK: - bind render
    func bindRender(viewModel: TextInputViewModel) {
        viewModel.state.map { $0.translateResult }
            .loading()
            .bind { [loadingView] isLoading in
                loadingView?.isHidden = !isLoading
            }
            .disposed(by: self.disposeBag)
        viewModel.state.map { $0.translateResult }
            .fail()
            .bind { [transitionDispatcher] errorMessage in
                transitionDispatcher.onNext(.errorAlert(errorMessage))
            }
            .disposed(by: self.disposeBag)
        viewModel.state.map { $0.translateResult }
            .success()
            .bind { [transitionDispatcher] result in
                transitionDispatcher.onNext(.translateResult(result))
            }
            .disposed(by: self.disposeBag)
    }

    // MARK: - bind transition
    func bindTransision(transitionDispatcher: PublishSubject<Transition>) {
        transitionDispatcher
            .bind { [weak self] transition in
                guard let self = self else { return }
                switch transition {
                case .translateResult:
                    let viewController = sharedTranslateResultContainer.resolve(TranslateResultViewController.self)!
                    self.navigationController?.pushViewController(viewController, animated: true)
                case .dismiss:
                    self.navigationController?.popViewController(animated: true)
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
