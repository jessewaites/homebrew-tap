class Cipherlab < Formula
  desc "Opinionated workspace for cipher research with AI coding agents"
  homepage "https://github.com/jessewaites/cipherlab"
  url "https://github.com/jessewaites/cipherlab/releases/download/v0.2.1/cipherlab_0.2.1_source.tar.gz"
  sha256 "8e51fcb79c4787c740358ee8a60a10ad2934aa50f1bef92490caec1bc075c77d"
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
    refute_path_exists testpath/"test-case/scripts/gpu-examples"
    assert_match "cuda", shell_output("#{bin}/cipherlab examples list")
    system bin/"cipherlab", "examples", "add", "cuda", "--project", testpath/"test-case"
    assert_path_exists testpath/"test-case/scripts/gpu-examples/cuda.cu"
    refute_path_exists testpath/"test-case/scripts/gpu-examples/metal.swift"
    system bin/"cipherlab", "validate", "--project", testpath/"test-case", "--json"
  end
end
