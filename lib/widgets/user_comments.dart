import 'package:flutter/material.dart';

class UserComments extends StatefulWidget {
  const UserComments({
    super.key,
  });

  @override
  State<UserComments> createState() => _UserCommentsState();
}

class _UserCommentsState extends State<UserComments> {
  final TextEditingController _commentController = TextEditingController();
  final List<Comment> _commentsList = [
    Comment(
      contents: '갑상선암 항암치료종료 3년 경과.',
      writer: '센터_이영지',
      writeDateTime: DateTime(2022, 9, 22, 10, 23, 10),
    ),
    Comment(
      contents: '최근 독감에 걸림. 면역력이 낮아진 상태',
      writer: '센터_이영지',
      writeDateTime: DateTime(2022, 11, 02, 12, 15, 6),
    ),
    Comment(
      contents: 'bmi가 비만단계로 증가.빵, 디저트 섭취 빈도가 잦음. 2일에 1번으로 줄이기로함',
      writer: '센터_송혜교',
      writeDateTime: DateTime(2023, 5, 17, 12, 34, 25),
    ),
    Comment(
      contents: 'bmi 과체중 진입. 저당 디저트 제품 권장',
      writer: '센터_송혜교',
      writeDateTime: DateTime(2023, 8, 30, 10, 26, 12),
    ),
    Comment(
      contents: '식단조절 스트레스로 식욕조절이 힘듦. 고강도 유산소 운동권장',
      writer: '센터_송혜교',
      writeDateTime: DateTime(2023, 12, 26, 11, 40, 56),
    ),
    Comment(
      contents: '잘못된 운동자세로 무릎 통증 호소. 필라테스로 운동종목 전환',
      writer: '센터_송혜교',
      writeDateTime: DateTime(2024, 5, 14, 12, 1, 21),
    ),
    Comment(
      contents: '변비 발생. 식이섬유 및 탄수화물 섭취량 늘리기를 권장',
      writer: '센터_전지현',
      writeDateTime: DateTime(2024, 7, 16, 11, 50, 11),
    ),
  ];

  void _addComment(String content) {
    if (content.trim().isEmpty) return;

    setState(() {
      _commentsList.add(Comment(
        contents: content,
        writer: '센터_이지은', // 현재 로그인된 사용자 정보로 대체
        writeDateTime: DateTime.now(),
      ));
    });

    _commentController.clear();
  }

  void _editComment(int index, String newContent) {
    if (newContent.trim().isEmpty) return;

    setState(() {
      _commentsList[index] = _commentsList[index].copyWith(
        contents: newContent,
        writeDateTime: DateTime.now(),
      );
    });
  }

  void _deleteComment(int index) {
    setState(() {
      _commentsList.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          child: Text(
            'Comments',
            textAlign: TextAlign.left,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 5),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey, width: 1),
            ),
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: _commentsList.length,
                    itemBuilder: (context, index) {
                      return CommentWidget(
                        comment: _commentsList[index],
                        onEdit: (newContent) => _editComment(index, newContent),
                        onDelete: () => _deleteComment(index),
                      );
                    },
                  ),
                ),
                const Divider(height: 1.0),
                _buildCommentInput(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCommentInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _commentController,
              decoration: const InputDecoration(
                hintText: ' Add comments',
                hintStyle: TextStyle(color: Colors.grey),
                border: InputBorder.none,
              ),
              maxLines: 5,
            ),
          ),
          ElevatedButton(
            onPressed: () => _addComment(_commentController.text),
            child: const Text('전송'),
          ),
        ],
      ),
    );
  }
}

class Comment {
  final String contents;
  final String writer;
  final DateTime writeDateTime;

  Comment({
    required this.contents,
    required this.writer,
    required this.writeDateTime,
  });

  Comment copyWith({
    String? contents,
    String? writer,
    DateTime? writeDateTime,
  }) {
    return Comment(
      contents: contents ?? this.contents,
      writer: writer ?? this.writer,
      writeDateTime: writeDateTime ?? this.writeDateTime,
    );
  }
}

class CommentWidget extends StatelessWidget {
  final Comment comment;
  final Function(String) onEdit;
  final VoidCallback onDelete;

  const CommentWidget({
    super.key,
    required this.comment,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showEditDialog(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(5),
            child: Text(
              comment.contents,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(width: 5),
              Text(
                comment.writer,
                style: const TextStyle(fontSize: 13, color: Colors.grey),
              ),
              const Spacer(),
              Text(
                '변경일시 ${_formatDateTime(comment.writeDateTime)}',
                style: const TextStyle(fontSize: 13, color: Colors.grey),
              ),
              const SizedBox(width: 5)
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} '
        '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}:${dateTime.second.toString().padLeft(2, '0')}';
  }

  void _showEditDialog(BuildContext context) {
    final TextEditingController controller =
        TextEditingController(text: comment.contents);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        contentPadding: EdgeInsets.only(left: 20, right: 20, bottom: 10),
        backgroundColor: Color(0xFFF2FEFF),
        title: Padding(
          padding: const EdgeInsets.only(bottom: 25),
          child: const Text(
            'Edit Comment',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        content: Container(
          padding: EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey, width: 1.0),
          ),
          height: 300,
          width: 440,
          child: TextField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: 'Enter new comment',
              border: InputBorder.none,
            ),
            maxLines: 8,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              onDelete();
              Navigator.pop(context);
            },
            child: Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
          SizedBox(
            width: 220,
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              onEdit(controller.text);
              Navigator.pop(context);
            },
            child: const Text(
              'Save',
            ),
          ),
        ],
      ),
    );
  }
}
