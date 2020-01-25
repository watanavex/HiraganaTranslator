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
    }

    let disposeBag = DisposeBag()
    let transitionDispatcher = PublishSubject<Transition>()

    @IBOutlet weak var backToTopButton: ThemeButton!
    @IBOutlet weak var backButton: ThemeButton!
    @IBOutlet weak var surfaceTextView: RoundTextView!
    @IBOutlet weak var furiganaTextView: RoundTextView!
    
    let translateResult: TranslateResult
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(translateResult: TranslateResult) {
        self.translateResult = translateResult
        
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupView()
        self.bindTransision(transitionDispatcher: self.transitionDispatcher)
    }

    // MARK: - setup view
    func setupView() {
        self.surfaceTextView.text = self.translateResult.surfaceCentence
        self.furiganaTextView.text = self.translateResult.furiganaCentence
        self.setupSyncScroll()
        
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

    // MARK: - bind transition
    func bindTransision(transitionDispatcher: PublishSubject<Transition>) {
        transitionDispatcher
            .bind { [weak self] transition in
                guard let self = self else { return }
                switch transition {
                case .menu:
                    self.navigationController?.popToRootViewController(animated: true)
                case .dismiss:
                    self.navigationController?.popViewController(animated: true)
                }
            }
            .disposed(by: self.disposeBag)
    }
}
