require "git-trim/version"

class GitTrim
  def run
    %x{git fetch -ap}

    if File.exists?(".git-protected-branches")
      protected_branches = File.read(".git-protected-branches").split("\n")
    end
    protected_branches ||= []
    protected_branches << "master"

    branches = %x{git branch --merged master}.split("\n").collect {|b| b.gsub('*', '').strip}
    branches -= protected_branches

    branches.each do |branch|
      puts %x{git branch -d #{branch}}
    end
  end
end
