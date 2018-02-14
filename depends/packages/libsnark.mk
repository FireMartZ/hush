package=libsnark

ifneq ($(host_os), mingw32)
  $(package)_version=0.1
  $(package)_download_path_linux=https://github.com/zcash/$(package)/archive/
  $(package)_file_name_linux=$(package)-$($(package)_git_commit_linux).tar.gz
  $(package)_download_file_linux=$($(package)_git_commit_linux).tar.gz
  $(package)_sha256_hash_linux=dad153fe46e2e1f33557a195cbe7d69aed8b19ed9befc08ddcb8c6d3c025941f
  $(package)_git_commit_linux=9ada3f84ab484c57b2247c2f41091fd6a0916573
else
  $(package)_download_path=https://github.com/radix42/$(package)/archive/
  $(package)_file_name=$(package)-$($(package)_git_commit).tar.gz
  $(package)_download_file=$($(package)_git_commit).tar.gz
  $(package)_sha256_hash=1f70df80b4852b5d55dc6e00af29e98f07b6758902d85a7814577e678296c005
  $(package)_git_commit=4015f558bb7a1b603de4ee1559c974389d3abb54
endif

define $(package)_set_vars
    $(package)_build_env=CC="$($(package)_cc)" CXX="$($(package)_cxx)"
    $(package)_build_env+=CXXFLAGS="$($(package)_cxxflags) -DBINARY_OUTPUT -DSTATICLIB -DNO_PT_COMPRESSION=1 "
endef

$(package)_dependencies=libgmp libsodium

define $(package)_build_cmds
  $(MAKE) lib DEPINST=$(host_prefix) CURVE=ALT_BN128 MULTICORE=1 NO_PROCPS=1 NO_GTEST=1 NO_DOCS=1 STATIC=1 NO_SUPERCOP=1 FEATUREFLAGS=-DMONTGOMERY_OUTPUT OPTFLAGS="-O2 -march=x86-64"
endef

define $(package)_stage_cmds
  $(MAKE) install STATIC=1 DEPINST=$(host_prefix) PREFIX=$($(package)_staging_dir)$(host_prefix) CURVE=ALT_BN128 NO_SUPERCOP=1
endef
