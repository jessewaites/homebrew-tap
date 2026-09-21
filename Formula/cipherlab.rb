class Cipherlab < Formula
  desc "Opinionated workspace for cipher research with AI coding agents"
  homepage "https://github.com/jessewaites/cipherlab"
  url "https://github.com/jessewaites/cipherlab/releases/download/v0.2.0/cipherlab_0.2.0_source.tar.gz"
  sha256 "e841d2818e7ffbf88790eb863e292aeba6f99f9ae605ca4dd5484b9f815f5870"
  license "MIT"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/cipherlab"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cipherlab version")
    system bin/"cipherlab", "new", "test-case", "--directory", testpath, "--non-interactive"
    assert_path_exists testpath/"test-case/AGENTS.md"
    assert_path_exists testpath/"test-case/WORKFLOW.md"
    system bin/"cipherlab", "validate", "--project", testpath/"test-case", "--json"
  end
end
