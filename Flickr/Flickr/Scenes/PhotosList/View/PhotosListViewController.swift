//
//  PhotosListViewController.swift
//  Flickr
//
//  Created by Taha on 18/05/2022.
//

import UIKit
import RxSwift

class PhotosListViewController: UIViewController {

    internal let disposeBag = DisposeBag()
    var viewModel: PhotosListViewModel!
    
    @IBOutlet weak var photosTableView: UITableView!
    @IBOutlet weak var indicator: BPCircleActivityIndicator!

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
        
        // viewModel.viewDidLoad()
        bindTableView()

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
            self?.viewModel.didSelectItemAtIndexPath(indexPath)
        }.disposed(by: disposeBag)
     
    }

    func showIndicator() {
        indicator.isHidden = false
        indicator.animate()
    }
        
    func hideIndicator() {
        indicator.isHidden = true
        indicator.stop()
    }

}

extension PhotosListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row % 5 == 0 && indexPath.row != 0 {
            // Ad Banner
            return 120
        } else {
            return 400
        }
    }

}
