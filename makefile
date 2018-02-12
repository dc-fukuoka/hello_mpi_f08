fc       = mpif90
fppflags = 
fflags   = -g -O3 -mavx
openmp   = -fopenmp
ldflags  =
libs     =
src      = hello.F90
bin1     = hello_mpi
bin2     = hello_hyb


all: $(bin1) $(bin2)

$(bin1): $(src)
	$(fc) $(fppflags) $(fflags) $^ -o $@ $(ldflags) $(libs)

$(bin2): $(src)
	$(fc) $(openmp) $(fppflags) $(fflags) $^ -o $@ $(ldflags) $(libs)

clean:
	rm -f $(bin1) $(bin2) *~ *.mod
