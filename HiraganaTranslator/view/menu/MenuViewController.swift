//
//  MenuViewController.swift
//  HiraganaTranslator
//
//  Created by susan on 2020/01/22
//  Copyright © 2020 Yohta Watanave. All rights reserved.
//
import UIKit
import RxSwift
import RxOptional
import Swinject
import SnapKit

class MenuViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    enum Transition: Equatable {
        case camera
        case textInput(initialText: String)
        case errorAlert(String)
    }

    private let viewModel: MenuViewModel
    private let alertService: AlertService
    private let disposeBag = DisposeBag()
    let transitionDispatcher = PublishSubject<Transition>()

    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var clipboardButton: UIButton!
    @IBOutlet weak var keyboardButton: UIButton!
    var loadingView: LoadingView!
    
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
        self.loadingView = LoadingView()
        self.view.addSubview(self.loadingView)
        self.loadingView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        self.loadingView.isHidden = true
        
        self.cameraButton.rx.tap
            .bind { [transitionDispatcher] in
                transitionDispatcher.onNext(.camera)
            }
            .disposed(by: self.disposeBag)
        self.keyboardButton.rx.tap
            .bind { [transitionDispatcher] in
                transitionDispatcher.onNext(.textInput(initialText: ""))
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
        self.clipboardButton.rx.tap
            .bind {
                viewModel.getStringFromPasteboard()
            }
            .disposed(by: self.disposeBag)
    }

    // MARK: - bind render
    func bindRender(viewModel: MenuViewModel) {
        viewModel.state.map { $0.pasteboardResult }
            .success()
            .bind { [transitionDispatcher] pastBoardString in
                transitionDispatcher.onNext(.textInput(initialText: pastBoardString))
            }
            .disposed(by: self.disposeBag)
        viewModel.state.map { $0.pasteboardResult }
            .fail()
            .bind { [transitionDispatcher] errorMessage in
                transitionDispatcher.onNext(.errorAlert(errorMessage))
            }
            .disposed(by: self.disposeBag)
        viewModel.state.map { $0.textRecognizeResult }
            .loading()
            .bind { [loadingView] isLoading in
                loadingView?.isHidden = !isLoading
            }
            .disposed(by: self.disposeBag)
        viewModel.state.map { $0.textRecognizeResult }
            .fail()
            .bind { [transitionDispatcher] errorMessage in
                transitionDispatcher.onNext(.errorAlert(errorMessage))
            }
            .disposed(by: self.disposeBag)
        viewModel.state.map { $0.textRecognizeResult }
            .success()
            .bind { [transitionDispatcher] resultText in
                transitionDispatcher.onNext(.textInput(initialText: resultText))
            }
            .disposed(by: self.disposeBag)
    }

    // MARK: - bind transition
    func bindTransision(transitionDispatcher: PublishSubject<Transition>) {
        transitionDispatcher
            .bind { transition in
                switch transition {
                case .camera:
                    let imagePicker = UIImagePickerController()
                    #if (!arch(i386) && !arch(x86_64))
                    imagePicker.sourceType = .camera
                    imagePicker.delegate = self
                    self.present(imagePicker, animated: true, completion: nil)
                    #elseif DEBUG
                    let url = Bundle.main.url(forResource: "image", withExtension: "png", subdirectory: "fixtures")!
                    let data = try? Data(contentsOf: url)
                    let image = UIImage(data: data!)
                    let info = [UIImagePickerController.InfoKey.originalImage: image as Any]
                    self.imagePickerController(imagePicker, didFinishPickingMediaWithInfo: info)
                    #endif
                case .textInput:
                    let viewController = sharedTextInputContainer.resolve(TextInputViewController.self)!
                    self.navigationController?.pushViewController(viewController, animated: true)
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
    
    // MARK: - UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
        }
        self.viewModel.textRecognize(image)
        picker.dismiss(animated: true, completion: nil)
    }
}
