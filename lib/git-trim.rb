require "git-trim/version"

class GitTrim
  def run(argv=nil)
    %x{git fetch -ap}

    if File.exist?(".git-protected-branches")
      protected_branches = File.read(".git-protected-branches").split("\n")
    end
    protected_branches ||= []
    protected_branches << "main"

    branches = %x{git branch --merged main}.split("\n").collect {|b| b.gsub('*', '').strip}
    branches -= protected_branches

    branches.each do |branch|
      puts %x{git branch -d #{branch}}
    end
  end

  def find_file(filename, directory=Dir.pwd)
    local_filename = File.expand_path(filename, directory)
    if File.exist?(local_filename)
      return local_filename
    elsif directory == "/"
      return nil
    else
      return find_file(filename, File.expand_path("..", directory))
    end
  end
end
