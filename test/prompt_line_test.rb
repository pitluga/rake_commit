require File.expand_path(File.dirname(__FILE__) + "/test_helper")

class PromptLineTest < Test::Unit::TestCase

  def test_message_puts_newline_if_saved_attribute_does_not_exist
    File.expects(:exists?).with(Dir.tmpdir + "/author.data").returns(false)
    RakeCommit::PromptLine.any_instance.expects(:puts).with("\n")
    assert_equal "author: ", RakeCommit::PromptLine.new("author").message
  end

  def test_message_puts_last_saved_attribute_if_exists
    File.expects(:exists?).with(Dir.tmpdir + "/author.data").returns(true)
    File.expects(:read).with(Dir.tmpdir + "/author.data").returns("Jane Doe\nJohn Doe\n")
    RakeCommit::PromptLine.any_instance.expects(:puts).with("\nprevious author: John Doe\n")
    assert_equal "author: ", RakeCommit::PromptLine.new("author").message
  end

  def test_save_history_will_save_entered_value_to_disk
    File.expects(:open).with(Dir.tmpdir + "/feature.data", "a").yields(file = mock)
    file.expects(:puts).with("card 100")
    RakeCommit::PromptLine.new("feature").save_history("card 100")
  end

  def test_skips_prompt_if_attribute_is_in_exclusions
    prompt_line = RakeCommit::PromptLine.new("author", ["author"])
    assert_equal nil, prompt_line.prompt
  end
end
