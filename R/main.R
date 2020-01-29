load_project_dir_skeleton <- function() {
  path <- system.file("extdata", "project-directory-setup.txt", package = "projkoc")
  read.csv(path, stringsAsFactors = FALSE, header = FALSE)
}

# rproj_file_exists <- function(proj_root_dir) {
#   length(list.files(proj_root_dir, pattern = "*.Rproj")) > 0
# }

create_util <- function(proj_root) {
  file.create(file.path(proj_root, "util.R"))
}

#' @export
setup_project_dir <- function() {

  # TODO: Check if project root dir

  proj_root <- rprojroot::find_rstudio_root_file()
  project_skeleton <- load_project_dir_skeleton()
  project_skeleton <- unlist(project_skeleton)

  dirs_to_create <- vapply(project_skeleton, function(x) file.path(proj_root, x), FUN.VALUE = character(1))

  for(dir in dirs_to_create) {
    dir.create(dir, recursive = TRUE)
  }

  create_util(proj_root)

}

#' @export
install_useful_packages <- function() {

  installed_pkgs <- installed.packages()
  installed_pkgs <- unlist(installed_pkgs[,1], use.names = FALSE)

  packages <- system.file("extdata", "favorite-packages.txt", package = "projkoc")
  packages <- read.csv(packages, header = FALSE, stringsAsFactors = FALSE)
  packages <- unlist(packages, use.names = FALSE)

  install_list <- vapply(packages, function(pkg) !pkg %in% installed_pkgs, FUN.VALUE = logical(1L))

  packages <- packages[install_list]

  if(length(packages) > 0) {
    install.packages(packages, repos = "https://cran.rstudio.com/")
  }

}
