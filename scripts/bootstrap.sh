echo "Bootstrapping..."

# functions definition
#-------------------------------------------------------------------------------
containsElement () {
  local e
  for e in "${@:2}"; do
	[[ "$e" == "$1" ]] && return 0
  done
  return 1
}

# variables definition
#-------------------------------------------------------------------------------
VAGRANT_HOME="/home/vagrant"
MY_HOME="$VAGRANT_HOME/data-science"
N_CPUS=6
MY_NAME="minutestatistique"
MY_EMAIL="data.science.fr@gmail.com"
MY_EDITOR="vim"

#PROGS=(R VW libsvm liblinear scala spark sbt kafka python psql)
PROGS=(R VW libsvm liblinear python psql)

PCRE_LNK="https://sourceforge.net/projects/pcre/files/pcre/8.40/pcre-8.40.tar.gz"
PCRE_ARCH="$(echo "$PCRE_LNK" | rev | cut -d/ -f1 | rev)"
PCRE=${PCRE_ARCH/.tar.gz/""}

MPI_LNK="https://www.open-mpi.org/software/ompi/v2.0/downloads/openmpi-2.0.2.tar.gz"
MPI_ARCH="$(echo "$MPI_LNK" | rev | cut -d/ -f1 | rev)"
MPI=${MPI_ARCH/.tar.gz/""}

R_LNK="https://cran.r-project.org/src/base/R-3/R-3.4.1.tar.gz"
R_ARCH="$(echo "$R_LNK" | rev | cut -d/ -f1 | rev)"
R=${R_ARCH/.tar.gz/""}

RSTUDIO_LNK="https://download2.rstudio.org/rstudio-server-1.0.153-amd64.deb"
RSTUDIO_ARCH="$(echo "$RSTUDIO_LNK" | rev | cut -d/ -f1 | rev)"

VW_LNK="https://github.com/JohnLangford/vowpal_wabbit.git"
VW_GIT="$(echo "$VW_LNK" | rev | cut -d/ -f1 | rev)"
VW=${VW_GIT/.git/""}

LIBSVM_LNK="https://github.com/cjlin1/libsvm.git"
LIBSVM_GIT="$(echo "$LIBSVM_LNK" | rev | cut -d/ -f1 | rev)"
LIBSVM=${LIBSVM_GIT/.git/""}

LIBLINEAR_LNK="https://github.com/cjlin1/liblinear.git"
LIBLINEAR_GIT="$(echo "$LIBLINEAR_LNK" | rev | cut -d/ -f1 | rev)"
LIBLINEAR=${LIBLINEAR_GIT/.git/""}

SCALA_LNK="https://downloads.lightbend.com/scala/2.12.3/scala-2.12.3.tgz"
SCALA_ARCH="$(echo "$SCALA_LNK" | rev | cut -d/ -f1 | rev)"
SCALA=${SCALA_ARCH/.tgz/""}

SPARK_LNK="https://d3kbcqa49mib13.cloudfront.net/spark-2.2.0-bin-hadoop2.7.tgz"
SPARK_ARCH="$(echo "$SPARK_LNK" | rev | cut -d/ -f1 | rev)"
SPARK=${SPARK_ARCH/.tgz/""}

SBT_LNK="https://cocl.us/sbt-1.0.1.tgz"
SBT_ARCH="$(echo "$SBT_LNK" | rev | cut -d/ -f1 | rev)"
SBT=${SBT_ARCH/.tgz/""}
SBT="$(echo "$SBT" | cut -d- -f1)""-launcher-packaging-""$(echo "$SBT" | cut -d- -f2)"

KAFKA_LNK="http://apache.crihan.fr/dist/kafka/0.11.0.0/kafka-0.11.0.0-src.tgz"
KAFKA_ARCH="$(echo "$KAFKA_LNK" | rev | cut -d/ -f1 | rev)"
KAFKA=${KAFKA_ARCH/.tgz/""}

TF_LNK="https://storage.googleapis.com/tensorflow/linux/cpu/tensorflow-1.0.1-cp27-none-linux_x86_64.whl"

# update repo
#-------------------------------------------------------------------------------
# ubuntu-14.04 only
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E084DAB9

sudo apt-get update
#sudo apt-get upgrade -y	# TODO how to force graphical answers to Yes

# install some utilities
#-------------------------------------------------------------------------------
sudo apt-get install -y byobu vim htop git build-essential

# install dev packages
#-------------------------------------------------------------------------------
if containsElement "psql" "${PROGS[@]}"
then
	echo "preparing to install psql and associated tools..."
	sudo apt-get install -y postgresql postgresql-contrib
	#sudo -i -u postgres
fi

if containsElement "R" "${PROGS[@]}"
then
	echo "preparing to install R and associated tools..."
	# R
	sudo apt-get install -y default-jdk gfortran libreadline-dev xorg-dev \
		libbz2-dev liblzma-dev libpcre3-dev libcurl4-openssl-dev libjpeg-dev \
		libtiff5-dev libcairo2-dev libicu-dev gobjc++ texlive texinfo \
		texlive-fonts-extra
	# RStudio Server Open Source
	sudo apt-get install -y gdebi-core
	# R packages
	sudo apt-get install -y libopenmpi-dev libgmp3-dev libmpfr-dev \
		libmpfr-doc libmpfr4 libmpfr4-dbg tcl8.6 tk8.6 tcl8.6-dev tk8.6-dev \
		tcl8.6-doc tk8.6-doc postgresql libpq-dev unixodbc unixodbc-dev \
		libmagick++-dev libpoppler-cpp-dev libpoppler-glib-dev libwebp-dev \
		openmpi-bin openmpi-doc libopenmpi-dev
fi

if containsElement "VW" "${PROGS[@]}"
then
	# vowpal wabbit
	#sudo apt-get install -y libboost-program-options-dev zlib1g-dev \
	#	libboost-python-dev
	sudo apt-get install -y vowpal-wabbit
fi

if containsElement "python" "${PROGS[@]}"
then
	# tensorflow
	sudo apt-get install -y python-pip python-dev 
	# scikit-learn
	sudo apt-get install -y python-setuptools libatlas-dev libatlas3gf-base
	sudo update-alternatives --set libblas.so.3 \
    /usr/lib/atlas-base/atlas/libblas.so.3
	sudo update-alternatives --set liblapack.so.3 \
    /usr/lib/atlas-base/atlas/liblapack.so.3
fi

# deploy tree
#-------------------------------------------------------------------------------
mkdir $MY_HOME
cd $MY_HOME
mkdir src work doc
cd work && mkdir R python java js c c++ scala spark tensorflow clojure
cd ../src

if containsElement "R" "${PROGS[@]}"
then
	echo "installing R and associated tools..."
	# install pcre-8.40
	#-------------------------------------------------------------------------------
	wget $PCRE_LNK
	tar -xzf $PCRE_ARCH
	rm -rf $PCRE_ARCH
	cd $PCRE
	./configure --prefix=/usr                     \
				--docdir=/usr/share/doc/$PCRE	  \
				--enable-unicode-properties       \
				--enable-pcre16                   \
				--enable-pcre32                   \
				--enable-pcregrep-libz            \
				--enable-pcregrep-libbz2          \
				--enable-pcretest-libreadline     \
				--disable-static                 &&
	make -j$N_CPUS
	make check
	sudo make install                     &&
	sudo mv -v /usr/lib/libpcre.so.* /lib &&
	sudo ln -sfv ../../lib/$(readlink /usr/lib/libpcre.so) /usr/lib/libpcre.so
	cd ..
	
	# install open-mpi
	#-------------------------------------------------------------------------------
	# wget $MPI_LNK
	# tar -xzf $MPI_ARCH
	# rm -rf $MPI_ARCH
	# cd $MPI
	# ./configure --prefix=/usr/local
	# make -j$N_CPUS all
	# make check
	# FAIL
	# sudo make install
	# cd ..
	
	# install R
	#-------------------------------------------------------------------------------
	wget $R_LNK
	tar -xzf $R_ARCH
	rm -rf $R_ARCH
	cd $R
	./configure --enable-R-shlib --enable-memory-profiling
	make -j$N_CPUS
	make check
	make check-devel
	sudo make install
	cd ..
	rm -rf $R
	
	# install R packages
	#-------------------------------------------------------------------------------
	cat > R_packages_installer.R <<- EOF
	#!/usr/bin/env Rscript
	print("installing R packages...")
	my.packages <- c(
	"RCurl", "yaml", "markdown", "knitr", "htmltools", "rmarkdown", "roxygen2",
	"pmml", "DMwR", "AppliedPredictiveModeling", "SuperLearner",
	"RMOA", "stream", "streamMOA",
	"foreign",
	"plyr", "dplyr", "splitstackshape", "matrixStats",
	"ggplot2", "shiny",
	"RODBC", "DBI", "RJDBC",
	"ff", "ffbase", "bigmemory", "biglm", "biglars", "biganalytics", "bigtabulate",
	"bigalgebra", "synchronicity", "data.table", "foreach", "Matrix", "iterators",
	"cluster", "MASS", "klaR", "mda", "Rcmdr", "relimp", "rpart", "missMDA",
	"nnet", "e1071", "randomForest", "tcltk2", "COBRA", "mvtnorm",
	"FactoMineR", "SensoMineR", "pls", "glmnet", "ssvd", "irlba", "gbm", "SOAR",
	"doMC", "doRNG", "earth", "fastICA", "gam", "ipred", "kernlab", "ellipse",
	"mgcv", "mlbench", "party", "pROC", "proxy", "RANN", "spls", "subselect",
	"pamr", "superpc", "Cubist", "testthat", "C50", "arm", "class", "cvAUC",
	"Hmisc", "lattice", "LogicReg", "nloptr", "polspline", "quadprog", "ROCR",
	"SIS", "stepPlr", "nnls", "LiblineaR", "Rcpp", "RVowpalWabbit", "hflights",
	"packS4", "R.methodsS3",
	"doMC", "doParallel",
	"XML", "rjson", "RJSONIO", "jsonlite",
	"qdapRegex",
	"devtools", "functional",
	"magrittr", "stringr",
	"Rmpfr", "bit64",
	"fpp", "darch", "caret", "caretEnsemble", "optimx", "Rpoppler",
	"archivist", "miniCRAN", "RGoogleAnalytics",
	"rbenchmark",
	"randomForestSRC", "KMsurv", "OIsurv", "survival", "coin",
	"tm", "lsa", "tau",
	"Rmpi", "doMPI",
	# NOT AVAILABLE
	# "gputools",
	# CONFIRMATION ANSWERS NEEDED
	# "RMySQL",
	# DEPRECATED
	# "roxygen", "bigrf", "tcltk", "genefilter", "sva", "randomSurvivalForest",
	# "rgl", "EMA", "mutoss",
	# DYNLOAD PB
	# "ridge",
	"microbenchmark",
	"packrat")
	install.packages(my.packages, repos = "http://cran.univ-paris1.fr",
					 dependencies = TRUE, Ncpus = $N_CPUS)
	EOF
	chmod u+x R_packages_installer.R
	sudo ./R_packages_installer.R

	# install rstudio-server open source
	#-------------------------------------------------------------------------------
	wget $RSTUDIO_LNK
	echo y | sudo gdebi $RSTUDIO_ARCH
	sudo rstudio-server verify-installation
	rm $RSTUDIO_ARCH
fi

# install vowpal wabbit
#-------------------------------------------------------------------------------
#if containsElement "VW" "${PROGS[@]}"
#then
	#git clone $VW_LNK
	#cd $VW
	#make -j$N_CPUS
	#make test
	#sudo make install
	#cd ..
	#rm -rf $VW
#fi

# install libsvm
#-------------------------------------------------------------------------------
if containsElement "libsvm" "${PROGS[@]}"
then
	git clone $LIBSVM_LNK
	cd $LIBSVM
	make
	cd ..
fi

# install libsvm
#-------------------------------------------------------------------------------
if containsElement "liblinear" "${PROGS[@]}"
then
	git clone $LIBLINEAR_LNK
	cd $LIBLINEAR
	make
	cd ..
fi

# install scala
#-------------------------------------------------------------------------------
if containsElement "scala" "${PROGS[@]}"
then
	wget $SCALA_LNK
	tar -xzf $SCALA_ARCH
	rm -rf $SCALA_ARCH
	ln -s $SCALA scala
	cat >> $VAGRANT_HOME/.bashrc <<- EOF

	# sbt
	export SCALA_HOME="$MY_HOME/src/scala"
	export PATH=\$PATH:\$SCALA_HOME/bin

	EOF
fi

# install spark
#-------------------------------------------------------------------------------
if containsElement "spark" "${PROGS[@]}"
then
	wget $SPARK_LNK
	tar -xzf $SPARK_ARCH
	rm -rf $SPARK_ARCH
	ln -s $SPARK spark
	cat >> $VAGRANT_HOME/.bashrc <<- EOF

	# spark
	export SPARK_HOME="$MY_HOME/src/spark"
	export PATH=\$PATH:\$SPARK_HOME/bin

	EOF
fi

# install sbt
#-------------------------------------------------------------------------------
if containsElement "sbt" "${PROGS[@]}"
then
	wget $SBT_LNK
	tar -xzf $SBT_ARCH
	rm -rf $SBT_ARCH
	#ln -s $SBT sbt
	cat >> $VAGRANT_HOME/.bashrc <<- EOF

	# sbt
	export SBT_HOME="$MY_HOME/src/sbt"
	export PATH=\$PATH:\$SBT_HOME/bin

	EOF
fi

# install kafka
#-------------------------------------------------------------------------------
if containsElement "kafka" "${PROGS[@]}"
then
	wget $KAFKA_LNK
	tar -xzf $KAFKA_ARCH
	rm -rf $KAFKA_ARCH
	ln -s  $KAFKA kafka
	cat >> $VAGRANT_HOME/.bashrc <<- EOF

	# kafka
	export KAFKA_HOME="$MY_HOME/src/kafka"
	export PATH=\$PATH:\$KAFKA_HOME/bin

	EOF
fi

# use byobu by default
#-------------------------------------------------------------------------------
cat >> $VAGRANT_HOME/.bashrc <<- EOF

# byobu
byobu

EOF

# vimrc
#-------------------------------------------------------------------------------
cat >> $VAGRANT_HOME/.vimrc <<- EOF

set nu hls
colorscheme koehler
set encoding=utf8
set fileencoding=utf8
set tabstop=2

EOF

# git config
#-------------------------------------------------------------------------------
git config --global user.name $MY_NAME
git config --global user.email $MY_EMAIL
git config --global core.editor $MY_EDITOR

# install knime
#-------------------------------------------------------------------------------
# https://download.knime.org/analytics-platform/linux/knime-full_3.3.1.linux.gtk.x86_64.tar.gz
# install h2o
#-------------------------------------------------------------------------------
# http://h2o-release.s3.amazonaws.com/h2o/rel-ueno/1/h2o-3.10.4.1.zip
# http://h2o-release.s3.amazonaws.com/sparkling-water/rel-2.1/0/sparkling-water-2.1.0.zip
# https://s3.amazonaws.com/steam-release/steam-1.1.6-linux-amd64.tar.gz
# install cassandra
#-------------------------------------------------------------------------------

if containsElement "python" "${PROGS[@]}"
then
	# upgrade pip
	#-------------------------------------------------------------------------------
	sudo pip install --upgrade pip

	# install tensorflow
	#-------------------------------------------------------------------------------
	sudo pip install --upgrade $TF_LNK

	# install python utilities
	#-------------------------------------------------------------------------------
	sudo pip install jupyter matplotlib pandas scipy
	pip install --user --install-option="--prefix=" -U scikit-learn
	
	# tensorflow works
	#-------------------------------------------------------------------------------
	cd $MY_HOME/work/tensorflow
	git clone https://github.com/floydhub/tensorflow-notebooks-examples.git
	git clone https://github.com/pkmital/tensorflow_tutorials.git
	git clone https://github.com/leriomaggio/deep-learning-keras-tensorflow.git
	
	# scikit-learn works
	#-------------------------------------------------------------------------------
	git clone https://github.com/minutestatistique/scikit-learn-examples.git
fi

# install java 8 for spark
if containsElement "spark" "${PROGS[@]}"
then
	echo "installing java 8 for spark and associated tools..."
	sudo apt-get install -y software-properties-common python-software-properties
	sudo add-apt-repository -y ppa:openjdk-r/ppa
	sudo apt-get update
	sudo apt-get install -y openjdk-8-jre
	#sudo update-alternatives --config java
fi

# source .bashrc
#-------------------------------------------------------------------------------
source $VAGRANT_HOME/.bashrc
