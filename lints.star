#!mesosphere/dispatch-starlark:v0.6

load("github.com/mesosphere/dispatch-catalog/starlark/stable/pipeline@0.0.6", "git_checkout_dir")

git_dir = "src-git"
git_resource(git_dir, url="$(context.git.url)", revision="$(context.git.branch)")

def shellcheck(task_name, paths):
    """
    Run the shellcheck linter on `paths` relative to the project root directory of the Git resource specified by `git_input`.
    """

    if not task_name:
        task_name = "shellcheck"

    if not paths:
        paths = []



    task(task_name,
        inputs=[git_dir],
        steps=[k8s.corev1.Container(
            name="shellcheck",
            image="koalaman/shellcheck:v0.7.1",
            workingDir=git_checkout_dir(git_dir),
            args=paths
         )])

    return task_name

