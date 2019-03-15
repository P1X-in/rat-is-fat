
const SCOREBOARD_FILE_PATH = 'user://scoreboard.rif'
const TOP_SIZE = 5

var bag
var scoreboard_node
var game_over_labels
var win_label
var win_label_low_score
var lose_label
var scores_node

var tag_query_node
var tag_query_score_node

var scores = []

var score_nodes = []

func _init_bag(bag):
    self.bag = bag
    self.scoreboard_node = self.bag.root.get_node("scoreboard")
    self.game_over_labels = self.scoreboard_node.get_node("center/game_over")
    self.win_label = self.game_over_labels.get_node("win")
    self.win_label_low_score = self.win_label.get_node("_low_score")
    self.lose_label = self.game_over_labels.get_node("lose")
    self.scores_node = self.scoreboard_node.get_node("center/scores")

    for i in range(self.TOP_SIZE):
        self.score_nodes.append(self.scores_node.get_node("score" + str(i)))

    self.tag_query_node = self.scoreboard_node.get_node("center/tag_query")
    self.tag_query_score_node = self.tag_query_node.get_node("score")

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
    self.tag_query_node.hide()

func show_success_with_score():
    self.win_label.show()
    self.win_label_low_score.hide()
    self.lose_label.hide()
    self.show_tag_query()

func show_success_without_score():
    self.win_label.show()
    self.win_label_low_score.show()
    self.lose_label.hide()
    self.show_scores_list()

func show_game_over():
    self.win_label.hide()
    self.lose_label.show()
    self.show_scores_list()

func show_tag_query():
    self.scores_node.hide()
    self.tag_query_node.show()
    self._fill_tag_query_score()

func show_scores_list():
    self.scores_node.show()
    self.tag_query_node.hide()
    self._fill_scoreboard()

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

func _fill_scoreboard():
    var scores_size = self.scores.size()
    var score

    for i in range(self.TOP_SIZE):
        if i >= scores_size:
            self.score_nodes[i].hide()
        else:
            score = self.scores[i]
            self.score_nodes[i].show()
            self.score_nodes[i].fill(score['tag'], score['players'][0], score['players'][1])

func _fill_tag_query_score():
    var player_0_score = self.bag.players.get_player_score(0)
    var player_1_score = self.bag.players.get_player_score(1)

    self.tag_query_score_node.fill("_____", player_0_score, player_1_score)
