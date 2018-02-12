program main
  !$ use omp_lib
  use mpi_f08
  implicit none
  integer :: cpu
  type(mpi_comm) :: comm
  integer :: iam, np, ierr
  character(len=16) :: hostname
  integer :: hostnm
  !$ integer :: iam_th, nth
  
  interface
     function sched_getcpu() result(cpu) bind(c, name="sched_getcpu")
       use,intrinsic :: iso_c_binding
       implicit none
       integer(c_int) :: cpu
     end function sched_getcpu
  end interface

  call mpi_init()
  comm = mpi_comm_world
  call mpi_comm_rank(comm, iam)
  call mpi_comm_size(comm, np)
  ierr = hostnm(hostname)
  !$omp parallel private(cpu, iam_th)
  cpu = sched_getcpu()
  !$ iam_th = omp_get_thread_num()
  !$omp single
  !$ nth    = omp_get_num_threads()
  !$omp end single
  !$omp critical
#ifdef _OPENMP
  write(6, '(a,5(a,i3))') trim(hostname), ": MPI: ", iam, "/", np, " OMP: ", iam_th, "/", nth, " cpu:", cpu
#else
  write(6, '(a,3(a,i3))') trim(hostname), ": MPI: ", iam, "/", np, " cpu:", cpu
#endif
  !$omp end critical
  !$omp end parallel
  call mpi_finalize()
  
  stop
end program main
