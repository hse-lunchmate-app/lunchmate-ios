//
//  ScheduleViewController.swift
//  lunchmate-ios
//
//  Created by Maria Slepneva on 27.02.2024.
//

import UIKit
import DateScrollPicker

protocol ScheduleViewControllerDelegate: AnyObject {
    func changeIsRightButtonEnabled()
    func changeIsLeftButtonEnabled()
}

class ScheduleViewController: UIViewController {
    
    private var viewModel = ScheduleViewModel()
    
    weak var delegate: ScheduleViewControllerDelegate?
    
    // MARK: - Subviews
    
    private let navigationTitle: UILabel = {
        let navigationTitle = UILabel()
        navigationTitle.text = "Расписание"
        navigationTitle.textColor = UIColor(named: "Base90")
        navigationTitle.font = UIFont(name: "SFPro-Semibold", size: 17)
        navigationTitle.sizeToFit()
        return navigationTitle
    }()
    
    private lazy var dataPickerCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(ScheduleCollectionViewCell.self, forCellWithReuseIdentifier: ScheduleCollectionViewCell.identifier)
        collectionView.register(DataPickerHeaderCollectionView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: DataPickerHeaderCollectionView.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor(named: "Base0")
        collectionView.contentInsetAdjustmentBehavior = .always
        collectionView.contentInset = UIEdgeInsets(top: 16, left: 16, bottom: 0, right: 16)
        (collectionView.collectionViewLayout as! UICollectionViewFlowLayout).estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        (collectionView.collectionViewLayout as! UICollectionViewFlowLayout).sectionInsetReference = .fromLayoutMargins
        return collectionView
    }()
    
    private lazy var slotsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(SlotsCollectionViewCell.self, forCellWithReuseIdentifier: SlotsCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = UIColor(named: "Base0")
        collectionView.contentInsetAdjustmentBehavior = .always
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 16, right: 16)
        (collectionView.collectionViewLayout as! UICollectionViewFlowLayout).sectionInsetReference = .fromLayoutMargins
        return collectionView
    }()
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getTimeTable()
    }
    
    // MARK: - Methods
    
    func bind() {
        viewModel.timeTable.bind { [weak self] timetable in
            DispatchQueue.main.async {
                self?.viewModel.getAllPermanentSlots()
                self?.dataPickerCollectionView.reloadData()
                self?.slotsCollectionView.reloadData()
            }
        }
    }
    
    func setupView() {
        view.backgroundColor = UIColor(named: "Base0")
        navigationItem.titleView = navigationTitle
        let backButton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backButton
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(
                systemName: "plus",
                withConfiguration: UIImage.SymbolConfiguration(
                    scale: .large
                )
            ),
            style: .plain,
            target: self,
            action: #selector(handleRightBarButtonTap)
        )
        [dataPickerCollectionView, slotsCollectionView].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        NSLayoutConstraint.activate([
            dataPickerCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            dataPickerCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            dataPickerCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            dataPickerCollectionView.heightAnchor.constraint(equalToConstant: 185),
            slotsCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            slotsCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            slotsCollectionView.topAnchor.constraint(equalTo: dataPickerCollectionView.bottomAnchor ),
            slotsCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    @objc func handleRightBarButtonTap() {
        openSlotSelection(isAddition: true, isSwitchEnable: true)
    }
    
    func openSlotSelection(isAddition: Bool, isSwitchEnable: Bool) {
        let slotAdditionViewModel = SlotAdditionViewModel()
        let slotAdditionController = SlotAdditionOverlayViewController(viewModel: slotAdditionViewModel)
        slotAdditionController.modalPresentationStyle = .custom
        slotAdditionController.transitioningDelegate = self
        slotAdditionController.delegate = self
        if let timeslot = viewModel.selectedTimeslot {
            slotAdditionViewModel.timeslot = timeslot
        }
        if let index = viewModel.selectedIndexPath?.row {
            let date = viewModel.getDatesOfCurrentWeek()[index]
            slotAdditionViewModel.setDate(newDate: date)
            slotAdditionViewModel.isAddition = isAddition
            if viewModel.permanentSlots[index] != nil && isAddition {
                slotAdditionViewModel.isSwitchEnable = false
            } else {
                slotAdditionViewModel.isSwitchEnable = isSwitchEnable
            }
        }
        present(slotAdditionController, animated: true, completion: nil)
        viewModel.selectedTimeslot = nil
    }
}

extension ScheduleViewController: UICollectionViewDelegate { }

extension ScheduleViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        SlotAdditionPresentationController(presentedViewController: presented, presenting: presenting)
    }
}

extension ScheduleViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == dataPickerCollectionView {
            return 5
        }
        else {
            return 0
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == dataPickerCollectionView {
            return 0
        }
        else {
            return 16
        }
    }
}

extension ScheduleViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == dataPickerCollectionView {
            return 7
        }
        else {
            let amount = viewModel.getInfoAboutMeetingsOfSelectedDay(selectedDay: nil).count
            if amount > 2 {
                navigationItem.rightBarButtonItem?.isEnabled = false
            }
            else {
                navigationItem.rightBarButtonItem?.isEnabled = true
            }
            return amount
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == dataPickerCollectionView {
            return CGSize(width: collectionView.frame.size.width / 7, height: 112)
        }
        else {
            return CGSize(width: collectionView.frame.size.width - 32, height: 94)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == dataPickerCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ScheduleCollectionViewCell.identifier, for: indexPath) as? ScheduleCollectionViewCell else {return UICollectionViewCell() }
            let date = viewModel.getDatesOfCurrentWeek()[indexPath.row]
            cell.configure(date: date)
            let data = viewModel.getInfoAboutMeetingsOfSelectedDay(selectedDay: indexPath)
            if data.count == 0 {
                cell.deleteImage()
            }
            if let ip = viewModel.selectedIndexPath {
                if indexPath.row == ip.row {
                    cell.changeSelectedCell()
                }
            }
            else {
                if indexPath.row == viewModel.getDifferenceOfCurrentDayOfWeek() {
                    cell.changeSelectedCell()
                    viewModel.selectedIndexPath = indexPath
                }
            }
            if indexPath.row == 6 || indexPath.row == 5 {
                cell.changeDisabledCell()
            }
            return cell
        }
        else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SlotsCollectionViewCell.identifier, for: indexPath) as? SlotsCollectionViewCell else {return UICollectionViewCell() }
            let data = viewModel.getInfoAboutMeetingsOfSelectedDay(selectedDay: nil).sorted(by: { $0.startTime < $1.startTime })[indexPath.row]
            let startTimeDate = viewModel.timeFormatter.date(from: data.startTime)
            let endTimeDate = viewModel.timeFormatter.date(from: data.endTime)
            viewModel.timeFormatter.dateFormat = "HH:mm"
            if let start = startTimeDate {
                let startTime = viewModel.timeFormatter.string(from: start)
                if let end = endTimeDate {
                    let endTime = viewModel.timeFormatter.string(from: end)
                    viewModel.timeFormatter.dateFormat = "HH:mm:ss"
                    cell.configure(timeslot: data, start: startTime, end: endTime)
                }
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if collectionView == dataPickerCollectionView {
            return CGSize(width: view.frame.size.width, height: 42)
        }
        else {
            return CGSize(width: 0, height: 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if collectionView == dataPickerCollectionView {
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: DataPickerHeaderCollectionView.identifier, for: indexPath) as? DataPickerHeaderCollectionView else { return UICollectionReusableView() }
            header.delegate = self
            self.delegate = header
            let months = viewModel.getMonths(dates: viewModel.getDatesOfCurrentWeek()).sorted(by: <)
            var title = months[0]
            if months.count == 2 {
                title += " - \(months[1])"
            }
            header.configure(month: title)
            return header
        }
        else {
            return UICollectionReusableView()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == dataPickerCollectionView {
            if let selectedIndexPath = viewModel.selectedIndexPath {
                if let cell = collectionView.cellForItem(at: selectedIndexPath) as? ScheduleCollectionViewCell {
                    cell.changeUsualCell()
                }
            }
            if let cell = collectionView.cellForItem(at: indexPath) as? ScheduleCollectionViewCell {
                cell.changeSelectedCell()
                viewModel.selectedIndexPath = indexPath
                slotsCollectionView.reloadData()
            }
        }
        else {
            let slots = viewModel.getInfoAboutMeetingsOfSelectedDay(selectedDay: viewModel.selectedIndexPath).sorted(by: { $0.startTime < $1.startTime })
            viewModel.selectedTimeslot = slots[indexPath.row]
            if viewModel.selectedTimeslot?.permanent == true || viewModel.permanentSlots[(viewModel.selectedTimeslot?.weekDay ?? 1) - 1] == nil {
                openSlotSelection(isAddition: false, isSwitchEnable: true)
            } else {
                openSlotSelection(isAddition: false, isSwitchEnable: false)
            }
        }
    }
}

extension ScheduleViewController: DataPickerHeaderCollectionViewDelegate {
    func updateLeftWeek() {
        dataPickerCollectionView.reloadData()
        slotsCollectionView.reloadData()
        if !viewModel.updateChangeWeek(right: false) {
            delegate?.changeIsLeftButtonEnabled()
        }
    }
    
    func updateRightWeek() {
        dataPickerCollectionView.reloadData()
        slotsCollectionView.reloadData()
        if !viewModel.updateChangeWeek(right: true) {
            delegate?.changeIsRightButtonEnabled()
        }
    }
}

extension ScheduleViewController: SlotAdditionOverlayViewControllerDelegate {
    func reloadTimeTable() {
        viewModel.getTimeTable()
    }
}
