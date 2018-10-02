import UIKit

class TodoListViewController: UITableViewController {

    // MARK: - Properties
    private lazy var todos: Todos = {
        return Todos.load()
    }()
    
    private lazy var footer: TextFieldView = {
        let footer = TextFieldView.nibView
        footer.delegate = self
        return footer
    }()
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }()

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    // MARK: - Helpers
    private func setupUI() {

        navigationItem.rightBarButtonItem = editButtonItem

        tableView.register(cellType: ItemTableViewCell.self)
        tableView.tableFooterView = footer
        tableView.keyboardDismissMode = .interactive
        
        title = NSLocalizedString("My List", comment: "")
    }

    // MARK: - TableView dataSource Delegate
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ItemTableViewCell = tableView.dequeueReusableCell(for: indexPath)

        let item = todos.items[indexPath.row]
        var date: String?
        if let completionDate = item.completionDate {
            date = dateFormatter.string(from: completionDate)
        }
        
        cell.set(title: item.title,
                 subtitle: date,
                 isCompleted: item.isComplete)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            todos.items.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }

    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView,
        moveRowAt sourceIndexPath: IndexPath,
        to destinationIndexPath: IndexPath) {
            todos.items.swapAt(sourceIndexPath.row, destinationIndexPath.row)
            todos.save()
    }
    
    // MARK: - TableView Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Toggle item completion state
        var item = todos.items[indexPath.row]
        item.isComplete.toggle()
        item.completionDate = item.isComplete ? Date() : nil
        todos.items[indexPath.row] = item

        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}

// MARK: - TextFieldViewDelegate Extension
extension TodoListViewController: TextFieldViewDelegate {
    func textField(didEnter text: String) {
        let item = Item(title: text)
        todos.items.append(item)
        let newIndex = IndexPath(row: todos.items.count-1, section: 0)
        tableView.beginUpdates()
        tableView.insertRows(at: [newIndex], with: .automatic)
        tableView.endUpdates()
    }
}
