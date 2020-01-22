//
//  ___FILENAME___
//  ___PROJECTNAME___
//
//  Created by ___USERNAME___ on ___DATE___
//  ___COPYRIGHT___
//
import UIKit
import RxSwift

class ___VARIABLE_productName___ViewController: UIViewController {

    enum Transition {
        case errorAlert(String)
    }

    private let viewModel: ___VARIABLE_productName___ViewModel
    private let alertService: AlertService
    private let disposeBag = DisposeBag()
    let transitionDispatcher = PublishSubject<Transition>()

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(viewModel: ___VARIABLE_productName___ViewModel, alertService: AlertService) {
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
    }

    // MARK: - bind intent
    func bindIntent(viewModel: ___VARIABLE_productName___ViewModel) {
    }

    // MARK: - bind render
    func bindRender(viewModel: ___VARIABLE_productName___ViewModel) {
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