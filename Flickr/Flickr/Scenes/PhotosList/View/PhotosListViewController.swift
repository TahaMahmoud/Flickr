//
//  PhotosListViewController.swift
//  Flickr
//
//  Created by Taha on 18/05/2022.
//

import UIKit
import RxSwift
import Kingfisher

class PhotosListViewController: UIViewController {

    internal let disposeBag = DisposeBag()
    var viewModel: PhotosListViewModel!
    
    @IBOutlet weak var photosTableView: UITableView!
    @IBOutlet weak var indicator: BPCircleActivityIndicator!

    @IBOutlet weak var searchText: UITextField!
    
    let refreshControl = UIRefreshControl()

    override func viewDidAppear(_ animated: Bool) {
        title = "Recent"
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.prefersLargeTitles = true
        
        viewModel.viewDidLoad()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        bindIndicator()
        bindErrorMessage()
        
        bindTableView()
        
        bindSearch()
        
        setupRefershControl()
        
    }

    func setupRefershControl() {
        refreshControl.tintColor = .white
        if #available(iOS 10.0, *) {
            photosTableView.refreshControl = refreshControl
        } else {
            photosTableView.addSubview(refreshControl)
        }

        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
    }
    
    @objc private func refresh(_ sender: Any) {
        viewModel.viewDidLoad()
        refreshControl.endRefreshing()
    }
    
    func bindIndicator() {
        viewModel.indicator.subscribe { [weak self] status in
            status ? self?.showIndicator() : self?.hideIndicator()
        }.disposed(by: disposeBag)
    }
    
    func bindErrorMessage() {
        viewModel.error.subscribe { message in
            Helper.showErrorNotification(message: message)
        }.disposed(by: disposeBag)
    }

    func setupTableView() {
        photosTableView.delegate = self
        photosTableView.registerCellNib(cellClass: PhotoTableViewCell.self)
    }

    fileprivate func bindTableView() {
        viewModel.photos
            .bind(to: photosTableView.rx.items(
                    cellIdentifier: "PhotoTableViewCell",
                    cellType: PhotoTableViewCell.self)) { row, element, cell in
                let indexPath = IndexPath(row: row, section: 0)
                        cell.configure(viewModel: self.viewModel.photoViewModelAtIndexPath(indexPath))
            }
            .disposed(by: disposeBag)
        
        photosTableView.rx.itemSelected.subscribe {[weak self]  (indexPath) in
            guard let indexPath = indexPath.element else { return }
            let cell = self?.photosTableView.cellForRow(at: indexPath) as? PhotoTableViewCell
            self?.showFullScreen(photoView: cell?.photoView ?? UIImageView())
        }.disposed(by: disposeBag)
        
    }

    func showFullScreen(photoView: UIImageView) {
        let newImageView = UIImageView(image: photoView.image)
        newImageView.frame = UIScreen.main.bounds
        newImageView.backgroundColor = .black
        newImageView.contentMode = .scaleAspectFit
        newImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImage))
        newImageView.addGestureRecognizer(tap)
        self.view.addSubview(newImageView)
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = true
    }

    @objc func dismissFullscreenImage(sender: UITapGestureRecognizer) {
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = false
        sender.view?.removeFromSuperview()
    }
    
    func showIndicator() {
        indicator.isHidden = false
        indicator.animate()
    }
        
    func hideIndicator() {
        indicator.isHidden = true
        indicator.stop()
    }

    func bindSearch() {
        searchText.rx.text.orEmpty
            .throttle(RxTimeInterval.seconds(2), latest: true, scheduler: MainScheduler.instance)
                .subscribe(onNext: { searchValue in
                    self.viewModel.search(searchText: searchValue)
                }, onDisposed: nil)
            .disposed(by: disposeBag)
    }
    
}

extension PhotosListViewController: UITableViewDelegate{
   
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if viewModel.photoViewModelAtIndexPath(indexPath).isAdBanner {
            // Ad Banner
            return 120
        } else {
            return 400
        }
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        viewModel.didScroll(searchText: searchText.text ?? "", indexPath: indexPath)
    }
    
}
