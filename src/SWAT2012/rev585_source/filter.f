      subroutine filter
      
!!    ~ ~ ~ PURPOSE ~ ~ ~
!!    this subroutine calculates the reduction of pollutants in surface runoff
!!    due to an edge of field filter or buffer strip

!!    ~ ~ ~ INCOMING VARIABLES ~ ~ ~
!!    name        |units         |definition
!!    ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
!!    bactrolp    |# colonies/ha |less persistent bacteria transported to main
!!                               |channel with surface runoff
!!    bactrop     |# colonies/ha |persistent bacteria transported to main
!!                               |channel with surface runoff
!!    bactsedlp   |# colonies/ha |less persistent bacteria transported with 
!!                               |sediment in surface runoff
!!    bactsedp    |# colonies/ha |persistent bacteria transported with 
!!                               |sediment in surface runoff
!!    curyr       |none          |current year of simulation
!!    fsred(:)    |none          |reduction in bacteria loading from filter
!!                               |strip
!!    hru_dafr(:) |none          |fraction of watershed area in HRU
!!    hrupest(:)  |none          |pesticide use flag:
!!                               | 0: no pesticides used in HRU
!!                               | 1: pesticides used in HRU
!!    ihru        |none          |HRU number
!!    npmx        |none          |number of different pesticides used in
!!                               |the simulation
!!    nyskip      |none          |number of years to skip output summarization
!!                               |and printing
!!    pst_sed(:,:)|kg/ha         |pesticide loading from HRU sorbed onto
!!                               |sediment
!!    pst_surq(:,:)|kg/ha        |amount of pesticide type lost in surface
!!                               |runoff on current day in HRU
!!    sbactrolp   |# colonies/ha |average annual number of less persistent 
!!                               |bacteria transported to main channel
!!                               |with surface runoff in solution
!!    sbactrop    |# colonies/ha |average annual number of persistent bacteria
!!                               |transported to main channel with surface
!!                               |runoff in solution
!!    sbactsedlp  |# colonies/ha |average annual number of less persistent
!!                               |bacteria transported with sediment in
!!                               |surface runoff
!!    sbactsedp   |# colonies/ha |average annual number of persistent bacteria   
!!                               |transported with sediment in surface runoff
!!    sedminpa(:) |kg P/ha       |amount of active mineral phosphorus sorbed to
!!                               |sediment in surface runoff in HRU for day
!!    sedminps(:) |kg P/ha       |amount of stable mineral phosphorus sorbed to
!!                               |sediment in surface runoff in HRU for day
!!    sedorgn(:)  |kg N/ha       |amount of organic nitrogen in surface runoff
!!                               |in HRU for the day
!!    sedorgp(:)  |kg P/ha       |amount of organic phosphorus in surface runoff
!!                               |in HRU for the day
!!    sedyld(:)   |metric tons   |daily soil loss caused by water erosion
!!    surqno3(:)  |kg N/ha       |amount of NO3-N in surface runoff in HRU for
!!                               |the day
!!    surqsolp(:) |kg P/ha       |amount of soluble phosphorus in surface runoff
!!                               |in HRU for the day
!!    surfq(:)    |mm H2O        |surface runoff generated on day in HRU
!!    hru_ha(:)   |ha            |area of HRU in hectares
!!    vfscon(:)   |none          |Fraction of the total runoff from the entire field
!!                               |entering the most concentrated 10% of the VFS.
!!    vfsratio(:) |none          |Field area/VFS area ratio
!!    hru_slp(:)  |m/m           |average slope steepness




!!    ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~

!!    ~ ~ ~ OUTGOING VARIABLES ~ ~ ~
!!    name        |units         |definition
!!    ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
!!    bactrolp    |# colonies/ha |less persistent bacteria transported to main
!!                               |channel with surface runoff
!!    bactrop     |# colonies/ha |persistent bacteria transported to main
!!                               |channel with surface runoff
!!    bactsedlp   |# colonies/ha |less persistent bacteria transported with 
!!                               |sediment in surface runoff
!!    bactsedp    |# colonies/ha |persistent bacteria transported with 
!!                               |sediment in surface runoff
!!    pst_sed(:,:)|kg/ha         |pesticide loading from HRU sorbed onto
!!                               |sediment
!!    pst_surq(:,:)|kg/ha        |amount of pesticide type lost in surface
!!                               |runoff on current day in HRU
!!    sbactrolp   |# colonies/ha |average annual number of less persistent 
!!                               |bacteria transported to main channel
!!                               |with surface runoff in solution
!!    sbactrop    |# colonies/ha |average annual number of persistent bacteria
!!                               |transported to main channel with surface 
!!                               |runoff in solution
!!    sbactsedlp  |# colonies/ha |average annual number of less persistent
!!                               |bacteria transported with sediment in
!!                               |surface runoff
!!    sbactsedp   |# colonies/ha |average annual number of persistent bacteria
!!                               |transported with sediment in surface runoff
!!    sedminpa(:) |kg P/ha       |amount of active mineral phosphorus sorbed to
!!                               |sediment in surface runoff in HRU for day
!!    sedminps(:) |kg P/ha       |amount of stable mineral phosphorus sorbed to
!!                               |sediment in surface runoff in HRU for day
!!    sedorgn(:)  |kg N/ha       |amount of organic nitrogen in surface runoff
!!                               |in HRU for the day
!!    sedorgp(:)  |kg P/ha       |amount of organic phosphorus in surface runoff
!!                               |in HRU for the day
!!    sedyld(:)   |metric tons   |daily soil loss caused by water erosion
!!    surqno3(:)  |kg N/ha       |amount of NO3-N in surface runoff in HRU for
!!                               |the day
!!    surqsolp(:) |kg P/ha       |amount of soluble phosphorus in surface runoff
!!                               |in HRU for the day
!!    ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~

!!    ~ ~ ~ LOCAL DEFINITIONS ~ ~ ~
!!    name        |units         |definition
!!    ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
!!    j           |none          |HRU number
!!    k           |none          |counter
!!    drain_vfs1  |ha	           |drainage area of vfs section 1
!!    drain_vfs2  |ha	           |drainage area of vfs section 2
!!    area_vfs1   |ha	           |Area of vfs section 1
!!    area_vfs2   |ha	           |Area of vfs section 2
!!    vfs_depth1  |mm	           |Runoff Loading for vfs section 1
!!    vfs_depth2  |mm	           |Runoff Loading for vfs section 2
!!    vfs_sed1    |kg/m^2        |sediment loading for vfs section 1
!!    vfs_sed2    |kg/m^2        |sediment loading for vfs section 2
!!    surq_remove1|%             |Surface runoff removal for for vfs section 1
!!    surq_remove2|%             |Surface runoff removal for for vfs section 2
!!    surq_remove |%             |Average surface runoff removal for for entire vfs
!!    sed_remove1 |%             |sediment removal for for vfs section 1
!!    sed_remove2 |%             |sediment removal for for vfs section 2
!!    sed_remove  |%             |Average sediment removal for for entire vfs 
!!        remove1 |%             |Generic removal for for vfs section 1 
!!                               |(recycled for constituants)
!!        remove2 |%             |Generic removal for for vfs section 2 
!!                               |(recycled for constituants)
!!    orgn_remove |%	           |Average organic N removal from surface 
!!                               |runoff for for entire vfs
!! surqno3_remove |%	           |Average nitrate removal from surface 
!!                               |runoff for for entire vfs
!!   partp_remove |%	           |Average particulate P removal from surface
!!                               | runoff for for entire vfs
!!   solP_remove	|%	           |Average soluble P removal from surface 
!!                               |runoff for for entire vfs				
!!    ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~

!!    ~ ~ ~ ~ ~ ~ END SPECIFICATIONS ~ ~ ~ ~ ~ ~


      use parm

      integer :: j, k
      real :: sdrain_vfs1, drain_vfs2, area_vfs1, area_vfs2, vfs_depth1,
     & vfs_depth2, vfs_sed1, vfs_sed2, surq_remove1, surq_remove2,
     & surq_remove, sed_remove1, sed_remove2, sed_remove, remove1, 
     & remove2, orgn_remove, surqno3_remove, partp_remove, solP_remove,
     & sedtrap, xrem

      j = 0
      j = ihru

	if (i == 100) then 
	remove2=0
	end if


!! Filter only if there is some surface runoff
	if (surfq(j) > .0001) then

!! vfs comnposed of two sections one with more concentrated flow than the other

!! Calculate drainage area of vfs 1 2 3 in ha
	drain_vfs1 = (1-vfscon(j))* hru_ha(j)
	drain_vfs2 = ((1-vfsch(j)) * vfscon(j))* hru_ha(j)
	drain_vfs3 = vfscon(j) * vfsch(j) * hru_ha(j)

!! Calculate area of vfs 1 and 2 in ha
	area_vfs1 = hru_ha(j) * 0.9 / vfsratio(j)
	area_vfs2 = hru_ha(j) * 0.1 / vfsratio(j)

!!	Calculate drainage area to vfs area ratio (unitless)
	vfs_ratio1 = drain_vfs1/area_vfs1
	vfs_ratio2 = drain_vfs2/area_vfs2

!! calculate runoff depth over buffer area in mm
	vfs_depth1 = vfs_ratio1 * surfq(j)
	vfs_depth2 = vfs_ratio2 * surfq(j)

!! calculate sediment loading over buffer area in kg/m^2
	vfs_sed1 = (sedyld(j) / hru_ha(j) * 1000 * drain_vfs1) /
     & (area_vfs1 * 10000)
	vfs_sed2 = (sedyld(j) / hru_ha(j) * 1000 * drain_vfs2) /
     & (area_vfs2 * 10000)

!! calculate Runoff Removal by vfs (used for nutrient removal estimation only) based on runoff depth and ksat
!! Based on vfsmod simulations

      surq_remove1 = 75.8 - 10.8 * Log(vfs_depth1)+25.9*Log(sol_k(1,j))
	if (surq_remove1 > 100.) surq_remove1 = 100.
	if (surq_remove1 < 0.) surq_remove1 = 0.

      surq_remove2 = 75.8 - 10.8 * Log(vfs_depth2)+25.9*Log(sol_k(1,j))
	if (surq_remove2 > 100.) surq_remove2 = 100.
	if (surq_remove2 < 0.) surq_remove2 = 0.

	surq_remove = (surq_remove1 * drain_vfs1 + surq_remove2
     & * drain_vfs2)/hru_ha(j)

!! calculate sediment Removal 
!! Based on measured data from literature

	sed_remove1 = 79.0 - 1.04 * vfs_sed1 + 0.213 * surq_remove1 
	if (sed_remove1 > 100.) sed_remove1 = 100.
	if (sed_remove1 < 0.) sed_remove1 = 0.

	sed_remove2 = 79.0 - 1.04 * vfs_sed2 + 0.213 * surq_remove1 
	if (sed_remove2 > 100.) sed_remove2 = 100.
	if (sed_remove2 < 0.) sed_remove2 = 0.

	sed_remove = (sed_remove1 * drain_vfs1 + sed_remove2
     & * drain_vfs2)/hru_ha(j)	
	
	sedyld(j) = sedyld(j) * (1. - sed_remove / 100.)
      sedyld(j) = Max(0., sedyld(j))

	sedtrap = sedyld(j) * sed_remove / 100.
	xrem = 0.

	  if (sedtrap <= lagyld(j)) then
	    lagyld(j) = lagyld(j) - sedtrap
	  else
	    xrem = sedtrap - lagyld(j)
	    lagyld(j) = 0.
	    if (xrem <= sanyld(j)) then
	      sanyld(j) = sanyld(j) - xrem
	    else
	      xrem = xrem - sanyld(j)
	      sanyld(j) = 0.
	      if (xrem <= sagyld(j)) then
	        sagyld(j) = sagyld(j) - xrem
	      else
	        xrem = xrem - sagyld(j)
	        sagyld(j) = 0.
	        if (xrem <= silyld(j)) then
	          silyld(j) = silyld(j) - xrem
	        else
	          xrem = xrem - silyld(j)
	          silyld(j) = 0.
	          if (xrem <= clayld(j)) then
	            clayld(j) = clayld(j) - xrem
	          else
	            xrem = xrem - clayld(j)
	            clayld(j) = 0.
	          end if
	        end if
	      end if
	    end if
	  end if
        sanyld(j) = Max(0., sanyld(j))
        silyld(j) = Max(0., silyld(j))
        clayld(j) = Max(0., clayld(j))
        sagyld(j) = Max(0., sagyld(j))
        lagyld(j) = Max(0., lagyld(j))


!! Calculate Organic Nitrogen Removal
!! Based on measured data from literature

	remove1 = 0.036 * sed_remove1 ** 1.69
	if (remove1 > 100.) remove1 = 100.
	if (remove1 < 0.) remove1 = 0.

	remove2 = 0.036 * sed_remove2 ** 1.69
	if (remove2 > 100.) remove2 = 100.
	if (remove2 < 0.) remove2 = 0.
	
	orgn_remove = (remove1 * drain_vfs1 + remove2
     & * drain_vfs2)/hru_ha(j)
	sedorgn(j) = sedorgn(j) * (1. - orgn_remove / 100.)

!! calculate Nitrate removal from surface runoff
!! Based on measured data from literature
	
	remove1 = 39.4 + 0.584 * surq_remove1
	if (remove1 > 100.) remove1 = 100.
	if (remove1 < 0.) remove1 = 0.

	remove2 = 39.4 + 0.584 * surq_remove2
	if (remove2 > 100.) remove2 = 100.
	if (remove2 < 0.) remove2 = 0.

	surqno3_remove = (remove1 * drain_vfs1 + remove2
     & * drain_vfs2)/hru_ha(j)
	surqno3(j) = surqno3(j) * (1. - surqno3_remove / 100.)

!! calculate Particulate P removal from surface runoff
!!Based on measured data from literature

	remove1 = 0.903 * sed_remove1
	if (remove1 > 100.) remove1 = 100.
	if (remove1 < 0.) remove1 = 0.
	
	remove2 = 0.903 * sed_remove2
	if (remove2 > 100.) remove2 = 100.
	if (remove2 < 0.) remove2 = 0.

	partP_remove = (remove1 * drain_vfs1 + remove2
     & * drain_vfs2)/hru_ha(j)
	sedminpa(j) = sedminpa(j) * (1. - partP_remove / 100.)
	sedminps(j) = sedminps(j) * (1. - partP_remove / 100.)
	sedorgp(j) = sedorgp(j) * (1. - partP_remove / 100.)

!! Calculate Soluble P removal from surface runoff
!!  DP% = - 6.14 + 1.13 Runoff%
	remove1 = 29.3 + 0.51 * surq_remove1
	if (remove1 > 100.) remove1 = 100.
	if (remove1 < 0.) remove1 = 0.
	
	remove21 = 29.3 + 0.51 * surq_remove2
	if (remove2 > 100.) remove2 = 100.
	if (remove2 < 0.) remove2 = 0.

	solp_remove = (remove1 * drain_vfs1 + remove2
     & * drain_vfs2)/hru_ha(j)
	surqsolp(j) = surqsolp(j) * (1. - solp_remove / 100.)

!! Calculate pesticide removal 
!! based on the sediment and runoff removal only
      if (hrupest(j) == 1) then
        do k = 1, npmx
          pst_surq(k,j) = pst_surq(k,j) * (1. - surq_remove / 100.)
          pst_sed(k,j) = pst_sed(k,j) * (1. - sed_remove / 100.)
        end do
      end if


!! compute filter strip reduction
      bactrop = bactrop * (1. - surq_remove / 100.)
      bactrolp = bactrolp * (1. - surq_remove / 100.)
      bactsedp = bactsedp * (1. - sed_remove / 100.)
      bactsedlp = bactsedlp * (1. - sed_remove / 100.)


!! summary calculations
      if (curyr > nyskip) then
        sbactrop = sbactrop + bactrop * hru_dafr(j)
        sbactrolp = sbactrolp + bactrolp * hru_dafr(j)
        sbactsedp = sbactsedp + bactsedp * hru_dafr(j)
        sbactsedlp = sbactsedlp + bactsedlp * hru_dafr(j)
      end if
	end if


      return
      end

