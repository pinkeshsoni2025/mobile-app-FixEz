class Faq {
  final String question;
  final String answer;

  Faq({required this.question, required this.answer});

  factory Faq.fromJson(Map<String, dynamic> json) {
    return Faq(
      question: json['question'] ?? '',
      answer: json['answer'] ?? '',
    );
  }
}

class Help {
  final String category;
  final List<Faq> faqs;

  Help({required this.category, required this.faqs});

  factory Help.fromJson(Map<String, dynamic> json) {
    return Help(
      category: json['category'] ?? '',
      faqs: (json['faqs'] as List)
          .map((faq) => Faq.fromJson(faq))
          .toList(),
    );
  }
}
