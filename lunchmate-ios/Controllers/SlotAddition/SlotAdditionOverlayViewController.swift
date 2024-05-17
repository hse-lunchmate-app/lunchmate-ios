//
//  SlotAdditionOverlayViewController.swift
//  lunchmate-ios
//
//  Created by Maria Slepneva on 07.05.2024.
//

import UIKit

protocol SlotAdditionOverlayViewControllerDelegate: AnyObject {
    func reloadTimeTable()
}

class SlotAdditionOverlayViewController: UIViewController {
    
    // MARK: - Properties
    
    var pointOrigin: CGPoint?
    var viewModel: SlotAdditionViewModel
    weak var delegate: SlotAdditionOverlayViewControllerDelegate?
    
    // MARK: - Subviews
    
    let slideIdicator: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.layer.cornerRadius = 3
        return view
    }()
    
    let clockImageView: UIImageView = {
        let image = UIImage(systemName: "clock")
        let imageView = UIImageView(image: image)
        imageView.tintColor = UIColor(named: "Base80")
        return imageView
    }()
    
    let dateLabel: UILabel = {
        let dateLabel = UILabel()
        dateLabel.font = UIFont(name: "Roboto-Medium", size: 22)
        return dateLabel
    }()
    
    lazy var startTime: UIDatePicker =  {
        let timePicker = UIDatePicker()
        timePicker.datePickerMode = .time
        timePicker.addTarget(self, action: #selector(timePickerValueChanged), for: .valueChanged)
        return timePicker
    }()
    
    lazy var endTime: UIDatePicker =  {
        let timePicker = UIDatePicker()
        timePicker.datePickerMode = .time
        let calendar = Calendar.current
        if let newDate = calendar.date(byAdding: .hour, value: 1, to: Date()) {
            timePicker.setDate(newDate, animated: true)
        }
        timePicker.addTarget(self, action: #selector(timePickerValueChanged), for: .valueChanged)
        return timePicker
    }()
    
    let separatorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Roboto-Medium", size: 17)
        label.text = "—"
        return label
    }()
    
    let repeatImageView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(systemName: "repeat")
        imageView.image = image
        imageView.isHidden = true
        imageView.tintColor = UIColor(named: "Base90")
        return imageView
    }()
    
    let rightChevronImageView: UIImage? = {
        let image = UIImage(systemName: "chevron.right")?.withTintColor(UIColor(named: "Blue") ?? .blue)
        return image
    }()
    
    let collegueNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Roboto-Regular", size: 20)
        return label
    }()
    
    let cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("Отменить бронь", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.red.cgColor
        button.layer.cornerRadius = 16
        button.titleLabel?.font = UIFont(name: "Roboto-Regular", size: 16)
        return button
    }()
    
    let deleteButton: UIButton = {
        let button = UIButton()
        button.setTitle("Удалить", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.red.cgColor
        button.layer.cornerRadius = 16
        button.titleLabel?.font = UIFont(name: "Roboto-Regular", size: 16)
        return button
    }()
    
    let saveButton: UIButton = {
        let button = UIButton()
        button.setTitle("Сохранить", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(.white, for: .disabled)
        button.backgroundColor = UIColor(named: "Yellow")
        button.layer.cornerRadius = 16
        button.titleLabel?.font = UIFont(name: "Roboto-Regular", size: 16)
        return button
    }()
    
    let repeatEveryWeekSwitch: UISwitch = {
        let repeatEveryWeekSwitch = UISwitch()
        repeatEveryWeekSwitch.onTintColor = UIColor(named: "Blue10")
        repeatEveryWeekSwitch.thumbTintColor = UIColor(named: "Blue")
        return repeatEveryWeekSwitch
    }()
    
    let repeatEveryWeekLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Roboto-Regular", size: 16)
        label.text = "Повторять еженедельно"
        return label
    }()
    
    // MARK: - Init
    
    init(viewModel: SlotAdditionViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        bindViewModel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognizerAction))
        view.addGestureRecognizer(panGesture)
        deleteButton.addTarget(self, action: #selector(deleteSlot), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(saveSlot), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(cancelMeeting), for: .touchUpInside)
        setupUI()
    }
    
    override func viewDidLayoutSubviews() {
        if pointOrigin == nil {
            pointOrigin = self.view.frame.origin
        }
    }
    
    // MARK: - Methods
    
    @objc private func deleteSlot() {
        viewModel.deleteSlot()
    }
    
    func postTimeslot(timeslot: NetworkTimeslot) {
        viewModel.postTimeSlot(timeslot: timeslot)
    }
    
    func patchTimeslot(timeslot: NetworkTimeslot) {
        viewModel.patchTimeSlot(timeslot: timeslot)
    }
    
    @objc private func saveSlot() {
        var isSwitchOn = true
        if repeatEveryWeekSwitch.isHidden {
            isSwitchOn = false
        } else {
            isSwitchOn = repeatEveryWeekSwitch.isOn
        }
        let timeslot = viewModel.makeNetworkTimeslot(isSwitchOn: isSwitchOn, startTime: startTime.date, endTime: endTime.date)
        if viewModel.timeslot == nil {
            postTimeslot(timeslot: timeslot)
        } else {
            patchTimeslot(timeslot: timeslot)
        }
    }
    
    @objc private func cancelMeeting() {
        viewModel.revokeLunch()
    }
    
    private func bindViewModel() {
        viewModel.stringDate.bind({ [weak self] date in
            self?.dateLabel.text = date
        })
        viewModel.start.bind({ [weak self] start in
            self?.startTime.setDate(start, animated: true)
        })
        viewModel.end.bind({ [weak self] end in
            self?.endTime.setDate(end, animated: true)
        })
        viewModel.isReload.bind({ [weak self] isReload in
            if isReload == true {
                DispatchQueue.main.async {
                    self?.delegate?.reloadTimeTable()
                    self?.dismiss(animated: true, completion: nil)
                }
            }
        })
    }
    
    func setupUI() {
        view.backgroundColor = UIColor(named: "Base0")
        [slideIdicator, dateLabel, clockImageView, startTime, separatorLabel, endTime, repeatImageView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        NSLayoutConstraint.activate([
            slideIdicator.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            slideIdicator.heightAnchor.constraint(equalToConstant: 6),
            slideIdicator.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.15),
            slideIdicator.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            dateLabel.topAnchor.constraint(equalTo: slideIdicator.bottomAnchor, constant: 28),
            dateLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            dateLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            clockImageView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 33),
            clockImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            clockImageView.heightAnchor.constraint(equalToConstant: 24),
            clockImageView.widthAnchor.constraint(equalToConstant: 24),
            startTime.leadingAnchor.constraint(equalTo: clockImageView.trailingAnchor, constant: 16),
            endTime.leadingAnchor.constraint(equalTo: startTime.trailingAnchor, constant: 28),
            startTime.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 28),
            startTime.heightAnchor.constraint(equalToConstant: 34),
            endTime.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 28),
            endTime.heightAnchor.constraint(equalToConstant: 34),
            separatorLabel.leadingAnchor.constraint(equalTo: startTime.trailingAnchor, constant: 8),
            endTime.leadingAnchor.constraint(equalTo: separatorLabel.trailingAnchor, constant: 8),
            separatorLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 44),
            separatorLabel.heightAnchor.constraint(equalToConstant: 2),
            repeatImageView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 33),
            repeatImageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            repeatImageView.heightAnchor.constraint(equalToConstant: 24),
            repeatImageView.widthAnchor.constraint(equalToConstant: 24),
        ])
        if viewModel.lunch != nil {
            if viewModel.timeslot?.permanent == true {
                repeatImageView.isHidden = false
            }
            startTime.isUserInteractionEnabled = false
            endTime.isUserInteractionEnabled = false
            [collegueNameLabel, cancelButton].forEach {
                $0.translatesAutoresizingMaskIntoConstraints = false
                view.addSubview($0)
            }
            let attributedText = NSMutableAttributedString()
            let textString = NSAttributedString(string: viewModel.getCollegueName() ?? "")
            let imageAttachment = NSTextAttachment()
            imageAttachment.image = rightChevronImageView
            let imageString = NSAttributedString(attachment: imageAttachment)
            attributedText.append(imageString)
            attributedText.append(NSAttributedString("  "))
            attributedText.append(textString)
            collegueNameLabel.attributedText = attributedText
            NSLayoutConstraint.activate([
                collegueNameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
                collegueNameLabel.topAnchor.constraint(equalTo: startTime.bottomAnchor, constant: 28),
                collegueNameLabel.heightAnchor.constraint(equalToConstant: 24),
                cancelButton.topAnchor.constraint(equalTo: collegueNameLabel.bottomAnchor, constant: 28),
                cancelButton.heightAnchor.constraint(equalToConstant: 36),
                cancelButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
                cancelButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            ])
        }
        else {
            if viewModel.timeslot?.permanent == true {
                repeatEveryWeekSwitch.isOn = true
            }
            [repeatEveryWeekSwitch, repeatEveryWeekLabel, deleteButton, saveButton].forEach {
                $0.translatesAutoresizingMaskIntoConstraints = false
                view.addSubview($0)
            }
            NSLayoutConstraint.activate([
                deleteButton.topAnchor.constraint(equalTo: repeatEveryWeekSwitch.bottomAnchor, constant: 28),
                deleteButton.heightAnchor.constraint(equalToConstant: 36),
                deleteButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
                deleteButton.widthAnchor.constraint(equalToConstant: 150),
                saveButton.topAnchor.constraint(equalTo: repeatEveryWeekSwitch.bottomAnchor, constant: 28),
                saveButton.heightAnchor.constraint(equalToConstant: 36),
                saveButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
                saveButton.widthAnchor.constraint(equalToConstant: 150),
                repeatEveryWeekSwitch.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
                repeatEveryWeekSwitch.topAnchor.constraint(equalTo: startTime.bottomAnchor, constant: 28),
                repeatEveryWeekLabel.leadingAnchor.constraint(equalTo: repeatEveryWeekSwitch.trailingAnchor, constant: 12),
                repeatEveryWeekLabel.topAnchor.constraint(equalTo: startTime.bottomAnchor, constant: 32),
                repeatEveryWeekLabel.heightAnchor.constraint(equalToConstant: 24)
            ])
            if viewModel.isSwitchEnable == false {
                repeatEveryWeekLabel.removeFromSuperview()
                repeatEveryWeekSwitch.removeFromSuperview()
                if viewModel.isAddition == true {
                    deleteButton.removeFromSuperview()
                    var saveButtonWidthConstraint: NSLayoutConstraint?
                    for constraint in saveButton.constraints {
                        if constraint.firstAttribute == .width {
                            saveButtonWidthConstraint = constraint
                            break
                        }
                    }
                    if let widthConstraint = saveButtonWidthConstraint {
                        saveButton.removeConstraint(widthConstraint)
                    }
                    NSLayoutConstraint.activate([
                        saveButton.topAnchor.constraint(equalTo: startTime.bottomAnchor, constant: 28),
                        saveButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
                    ])
                } else {
                    NSLayoutConstraint.activate([
                        deleteButton.topAnchor.constraint(equalTo: startTime.bottomAnchor, constant: 28),
                        saveButton.topAnchor.constraint(equalTo: startTime.bottomAnchor, constant: 28),
                    ])
                }
            } else {
                if viewModel.isAddition == true {
                    deleteButton.removeFromSuperview()
                    var saveButtonWidthConstraint: NSLayoutConstraint?
                    for constraint in saveButton.constraints {
                        if constraint.firstAttribute == .width {
                            saveButtonWidthConstraint = constraint
                            break
                        }
                    }
                    if let widthConstraint = saveButtonWidthConstraint {
                        saveButton.removeConstraint(widthConstraint)
                    }
                    NSLayoutConstraint.activate([
                        saveButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
                    ])
                }
            }
        }
    }
    
    @objc func timePickerValueChanged() {
        let start = startTime.date
        let end = endTime.date
        if start > end {
            saveButton.isEnabled = false
            saveButton.backgroundColor = .lightGray
        }
        else {
            saveButton.isEnabled = true
            saveButton.backgroundColor = UIColor(named: "Yellow")
        }
    }
    
    @objc func panGestureRecognizerAction(sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        guard translation.y >= 0 else { return }
        view.frame.origin = CGPoint(x: 0, y: self.pointOrigin!.y + translation.y)
        
        if sender.state == .ended {
            let draggedToDismiss = (translation.y > view.frame.size.height/3.0)
            let dragVelocity = sender.velocity(in: view)
            if (dragVelocity.y >= 1300) || draggedToDismiss {
                self.dismiss(animated: true, completion: nil)
            } else {
                UIView.animate(withDuration: 0.3) {
                    self.view.frame.origin = self.pointOrigin ?? CGPoint(x: 0, y: 400)
                }
            }
        }
    }
}

