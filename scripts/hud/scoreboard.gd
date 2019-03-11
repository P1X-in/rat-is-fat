
const SCOREBOARD_FILE_PATH = 'user://scoreboard.rif'
const TOP_SIZE = 5

var bag
var scoreboard_node
var game_over_labels
var win_label
var lose_label
var scores_node

var scores = []

func _init_bag(bag):
    self.bag = bag
    self.scoreboard_node = self.bag.root.get_node("scoreboard")
    self.game_over_labels = self.scoreboard_node.get_node("center/game_over")
    self.win_label = self.game_over_labels.get_node("win")
    self.lose_label = self.game_over_labels.get_node("lose")
    self.scores_node = self.scoreboard_node.get_node("center/scores")
    self._initialize()

func _initialize():
    self.load_scores_from_file()

func show(win, timeout):
    var score = self.bag.players.get_summary_score()

    self.scoreboard_node.show()
    self.game_over_labels.show()
    if win:
        if self.is_eligible_for_board(score):
            self.show_success_with_score()
        else:
            self.show_success_without_score()
    else:
        self.show_game_over()


func hide():
    self.scoreboard_node.hide()
    self.game_over_labels.hide()
    self.scores_node.hide()

func show_success_with_score():
    self.win_label.show()
    self.lose_label.hide()
    self.show_tag_query()

func show_success_without_score():
    self.win_label.show()
    self.lose_label.hide()
    self.show_scores_list()

func show_game_over():
    self.win_label.hide()
    self.lose_label.show()
    self.show_scores_list()

func show_tag_query():
    self.scores_node.show()

func show_scores_list():
    self.scores_node.show()

func is_eligible_for_board(score):
    if self.scores.size() < self.TOP_SIZE:
        return true

    return score > self.scores[self.TOP_SIZE - 1]['score']

func add_score(tag, player_0_score, player_1_score):
    var summary_score = player_0_score

    if player_1_score != null:
        summary_score += player_1_score

    self.scores.append({
        'score' : summary_score,
        'players' : [player_0_score, player_1_score],
        'tag' : tag
    })

    self.scores.sort_custom(self, "_custom_scoreboard_sort")

    if self.scores.size() > self.TOP_SIZE:
        self.scores.pop_back()

    self.save_scores_to_file()

func load_scores_from_file():
    self.scores = self.bag.file_handler.read(self.SCOREBOARD_FILE_PATH)

func save_scores_to_file():
    self.bag.file_handler.write(self.SCOREBOARD_FILE_PATH, self.scores)


func _custom_scoreboard_sort(a, b):
    return a['score'] > b['score']
