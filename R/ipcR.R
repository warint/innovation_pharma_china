url <- paste0("https://warin.ca/datalake/innovation_pharma_china/innovation_pharma_china.csv")
path <- file.path(tempdir(), "temp.csv")
curl::curl_download(url, path)
# Reading data
csv_file <- file.path(paste0(tempdir(), "/temp.csv"))
IPC_data <- read.csv(csv_file)


# Function 1: Retrieving Data

#' ipcr_data
#'
#' @description This function allows you to find and display the dataset on Jaccard similarity coefficients for innovation dynamics in the pharmaceutical industry in China. .
#'
#' @return Complete dataset
#' @export
#'
#' @examples
#' myData <- ipcr_data()


ipcr_data <- function(){
  IPC_data
}


# Function 2: Visuals

#' ipcr_visual
#'
#' @description This function allows you to create 4 sorts of visuals: line, bar, box and point charts.
#'
#' @param chart Type of charts
#' @param class 4-digit class of patent
#' @param title  Chart title, set by default to TRUE
#'
#' @return Chosen Graph
#'
#' @import dplyr
#' @import ggplot2
#' @import ochRe
#' @import stringr
#' @importFrom stats aggregate
#' @export
#'
#' @examples
#' ipcr_visual()
ipcr_visual <- function(chart = "line_1", class = "b14s", title = TRUE){

  name_i <- vol_i <- name_j <- vol_j <- jpc_class <- year <- Jaccard_Similarity <- class_name <- NULL
  class_i <- year_diff <- year_i <- vol_j <- jpc_class <- NULL

  # Color palette
  pal <- ochRe::ochre_palettes$dead_reef
  # Choosing one color from the palette
  pal1 <- pal[2]

  if(chart == "line_1"){
    patent_vol_i <- dplyr::select(IPC_data, name_i, vol_i)
    patent_vol_i <- unique(patent_vol_i)
    patent_vol_j <- dplyr::select(IPC_data, name_j, vol_j)
    patent_vol_j <- patent_vol_j[1,]
    names(patent_vol_j) <- c("name_i", "vol_i")
    line_1 <- dplyr::bind_rows(patent_vol_j, patent_vol_i)
    line_1$name_i <- stringr::str_sub(line_1$name_i,-4,-1)
    line_1 <- stats::aggregate(vol_i ~ name_i, data = line_1, sum)
    line_1$name_i <- as.numeric(line_1$name_i)
    if(title == TRUE){
      ggplot2::ggplot(data = line_1) +
        ggplot2::geom_line(ggplot2::aes(x = name_i, y = vol_i), size = 0.8, color = pal1) +
        ggplot2::geom_point(ggplot2::aes(x = name_i, y = vol_i), size = 1.5, color = pal1) +
        ggplot2::ggtitle("Number of Chinese pharmaceutical patents (1990-2017)") +
        ggplot2::xlab("Years") + ggplot2::ylab("# patents") +
        ggplot2::theme_minimal() +
        ggplot2::theme(legend.position = "none") +
        ggplot2::scale_x_continuous(breaks = seq(from = 1990, to = 2017, by = 5))
    } else {
      ggplot2::ggplot(data = line_1) +
        ggplot2::geom_line(ggplot2::aes(x = name_i, y = vol_i), size = 0.8, color = pal1) +
        ggplot2::geom_point(ggplot2::aes(x = name_i, y = vol_i), size = 1.5, color = pal1) +
        ggplot2::ggtitle("") +
        ggplot2::xlab("Years") + ggplot2::ylab("# patents") +
        ggplot2::theme_minimal() +
        ggplot2::theme(legend.position = "none") +
        ggplot2::scale_x_continuous(breaks = seq(from = 1990, to = 2017, by = 5))
    }
  } else if(chart == "line_2" & class == jpc_class){
    patent_vol_i <- dplyr::select(IPC_data, name_i, vol_i)
    patent_vol_i <- unique(patent_vol_i)
    patent_vol_j <- dplyr::select(IPC_data, name_j, vol_j)
    patent_vol_j <- patent_vol_j[1,]
    names(patent_vol_j) <- c("name_i", "vol_i")
    line_2 <- dplyr::bind_rows(patent_vol_j, patent_vol_i)
    line_2$year <- stringr::str_sub(line_2$name_i,-4,-1)
    line_2$name_i <- stringr::str_sub(line_2$name_i, 1, 4)
    line_2 <- dplyr::filter(line_2, name_i == class)
    line_2$year <- as.numeric(line_2$year)
    if(title == TRUE){
      ggplot2::ggplot(data = line_2) +
        ggplot2::geom_line(ggplot2::aes(x = year, y = vol_i), size = 0.8, color = pal1) +
        ggplot2::geom_point(ggplot2::aes(x = year, y = vol_i), size = 1.5, color = pal1) +
        ggplot2::ggtitle(paste("Number of patents for class", class,"(1990-2017)")) +
        ggplot2::xlab("Years") + ggplot2::ylab("# patents") +
        ggplot2::theme_minimal() +
        ggplot2::theme(legend.position = "none") +
        ggplot2::scale_x_continuous(breaks = seq(from = 1990, to = 2017, by = 5))
    } else {
      ggplot2::ggplot(data = line_2) +
        ggplot2::geom_line(ggplot2::aes(x = year, y = vol_i), size = 0.8, color = pal1) +
        ggplot2::geom_point(ggplot2::aes(x = year, y = vol_i), size = 1.5, color = pal1) +
        ggplot2::ggtitle(paste("")) +
        ggplot2::xlab("Years") + ggplot2::ylab("# patents") +
        ggplot2::theme_minimal() +
        ggplot2::theme(legend.position = "none") +
        ggplot2::scale_x_continuous(breaks = seq(from = 1990, to = 2017, by = 5))
    }
  } else if(chart == "bar_1"){
    patent_vol_i <- dplyr::select(IPC_data, name_i, vol_i)
    patent_vol_i <- unique(patent_vol_i)
    patent_vol_j <- dplyr::select(IPC_data, name_j, vol_j)
    patent_vol_j <- patent_vol_j[1,]
    names(patent_vol_j) <- c("name_i", "vol_i")
    bar_1 <- dplyr::bind_rows(patent_vol_j, patent_vol_i)
    bar_1$name_i <- stringr::str_sub(bar_1$name_i, 1, 4)
    bar_1 <- aggregate(vol_i ~ name_i, data = bar_1, sum)
    bar_1 <- dplyr::arrange(bar_1, desc(vol_i))
    bar_1$name_i <- factor(bar_1$name_i, levels = unique(bar_1$name_i)[order(bar_1$vol_i)])
    if(title == TRUE){
      ggplot2::ggplot(data = bar_1, ggplot2::aes(x = name_i, y = vol_i)) +
        ggplot2::geom_col(fill = pal1) +
        ggplot2::xlab("Manual code class") + ggplot2::ylab("# patents") +
        ggplot2::ggtitle("Number of patents per Derwent manual code sections \n(1990-2017)") +
        ggplot2::theme_minimal() +
        ggplot2::theme(legend.position = "none") +
        ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 90, vjust = 0.5, hjust=1))
    } else {
      ggplot2::ggplot(data = bar_1, ggplot2::aes(x = name_i, y = vol_i)) +
        ggplot2::geom_col(fill = pal1) +
        ggplot2::xlab("Manual code class") + ggplot2::ylab("# patents") +
        ggplot2::ggtitle("") +
        ggplot2::theme_minimal() +
        ggplot2::theme(legend.position = "none") +
        ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 90, vjust = 0.5, hjust=1))
    }
  } else if(chart == "box_1"){
    box_1 <- dplyr::select(IPC_data, name_i, name_j, Jaccard_Similarity, class)
    box_1$class <- as.factor(box_1$class)
    box_1$class_name <- ifelse(box_1$class == 1, "Same class", "Different class")
    if(title == TRUE){
      ggplot2::ggplot(box_1, ggplot2::aes(class_name, Jaccard_Similarity)) +
        ggplot2::geom_boxplot() +
        ggplot2::geom_boxplot(fill=pal1, color="black") +
        ggplot2::theme_minimal() +
        ggplot2::xlab("Class") +
        ggplot2::ylab("Jaccard similarity")+
        ggplot2::ggtitle("Jaccard similarity distribution for same/different class") +
        ggplot2::stat_summary(fun=mean, geom="point", shape=23, size=4)
    } else {
      ggplot2::ggplot(box_1, ggplot2::aes(class_name, Jaccard_Similarity)) +
        ggplot2::geom_boxplot() +
        ggplot2::geom_boxplot(fill=pal1, color="black") +
        ggplot2::theme_minimal() +
        ggplot2::xlab("Class") +
        ggplot2::ylab("Jaccard similarity")+
        ggplot2::ggtitle("") +
        ggplot2::stat_summary(fun=mean, geom="point", shape=23, size=4)
    }
  } else if(chart == "box_2"){
    box_2 <- dplyr::select(IPC_data, class_i, Jaccard_Similarity)
    if(title == TRUE){
      ggplot2::ggplot(box_2, ggplot2::aes(x=class_i, y=Jaccard_Similarity)) +
        ggplot2::geom_boxplot() +
        ggplot2::geom_boxplot(fill=pal1, color="black") +
        ggplot2::theme_minimal() +
        ggplot2::xlab("Manual code class") +
        ggplot2::ylab("Jaccard similarity") +
        ggplot2::ggtitle("Jaccard similarity distribution of the Derwent manual code sections") +
        ggplot2::stat_summary(fun=mean, geom="point", shape=23, size=4) +
        ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 90, vjust = 0.5, hjust=1))
    } else {
      ggplot2::ggplot(box_2, ggplot2::aes(x=class_i, y=Jaccard_Similarity)) +
        ggplot2::geom_boxplot() +
        ggplot2::geom_boxplot(fill=pal1, color="black") +
        ggplot2::theme_minimal() +
        ggplot2::xlab("Manual code class") +
        ggplot2::ylab("Jaccard similarity") +
        ggplot2::ggtitle("") +
        ggplot2::stat_summary(fun=mean, geom="point", shape=23, size=4) +
        ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 90, vjust = 0.5, hjust=1))
    }
  } else if(chart == "box_3"){
    box_3 <- dplyr::select(IPC_data, class, class_i, year_diff, year_i, Jaccard_Similarity)
    box_3 <- dplyr::filter(box_3, year_diff!=0)
    box_3 <- dplyr::filter(box_3, class==0)
    box_3 <- dplyr::filter(box_3, class_i=="b14s")
    box_3$year_i <- as.factor(box_3$year_i)
    if(title == TRUE){
      ggplot2::ggplot(box_3, ggplot2::aes(x=year_i, y=Jaccard_Similarity)) +
        ggplot2::geom_boxplot() +
        ggplot2::geom_boxplot(fill=pal1, color="black") +
        ggplot2::theme_minimal() +
        ggplot2::xlab("") +
        ggplot2::ylab("Jaccard similarity") +
        ggplot2::ggtitle(paste("Jaccard similarity distribution per year for class", class)) +
        ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 90, vjust = 0, hjust=1)) +
        ggplot2::stat_summary(fun=mean, geom="point", shape=23, size=4)
    } else {
      ggplot2::ggplot(box_3, ggplot2::aes(x=year_i, y=Jaccard_Similarity)) +
        ggplot2::geom_boxplot() +
        ggplot2::geom_boxplot(fill=pal1, color="black") +
        ggplot2::theme_minimal() +
        ggplot2::xlab("") +
        ggplot2::ylab("Jaccard similarity") +
        ggplot2::ggtitle("") +
        ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 90, vjust = 0, hjust=1)) +
        ggplot2::stat_summary(fun=mean, geom="point", shape=23, size=4)
    }
  } else if(chart == "point_1"){
    point_1 <- dplyr::select(IPC_data, class, class_i, year_diff, Jaccard_Similarity)
    point_1 <- dplyr::filter(point_1, class==0)
    point_1 <- dplyr::filter(point_1, class_i=="b14s")
    if(title == TRUE){
      ggplot2::ggplot(point_1, ggplot2::aes(x=year_diff, y=Jaccard_Similarity)) +
        ggplot2::geom_point(color = pal1) +
        ggplot2::theme_minimal()  +
        ggplot2::ggtitle(paste("Jaccard Similarity distribution for class", class, "per time lag")) +
        ggplot2::xlab("Time lag") +
        ggplot2::ylab("Jaccard similarity")
    } else {
      ggplot2::ggplot(point_1, ggplot2::aes(x=year_diff, y=Jaccard_Similarity)) +
        ggplot2::geom_point(color = pal1) +
        ggplot2::theme_minimal()  +
        ggplot2::ggtitle("") +
        ggplot2::xlab("Time lag") +
        ggplot2::ylab("Jaccard similarity")
    }
  } else {
    stop("invalid arguments")
  }
}
