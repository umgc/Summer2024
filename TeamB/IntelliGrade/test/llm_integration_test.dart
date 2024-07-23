import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intelligrade/api/llm/llm_api.dart';

Future main() async {
  // load env
  await dotenv.load(fileName: 'assets/env.env');
  print('PERPLEXITY_API_KEY=${dotenv.env['PERPLEXITY_API_KEY']}');

  // test LLM connection
  const llmMsg = 'How many stars are there in our galaxy?'; // no-charge query
  print('LLM Post: $llmMsg');
  final llm = LlmApi(dotenv.env['PERPLEXITY_API_KEY']!);
  final String llmResp = await llm.postToLlm(llmMsg);
  print('LLM Resp: $llmResp');
}