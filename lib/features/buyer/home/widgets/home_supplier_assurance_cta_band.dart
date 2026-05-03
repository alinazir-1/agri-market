import 'package:flutter/material.dart';

import 'package:agri_market/core/constants/colors.dart';
import 'package:agri_market/core/constants/sizes.dart';
import 'package:agri_market/shared/widgets/common/app_container.dart';
import 'package:agri_market/shared/widgets/common/app_text.dart';

class HomeSupplierAssuranceCtaBand extends StatelessWidget {
  const HomeSupplierAssuranceCtaBand({super.key});

  static const List<({String name, String city, String specialty, String badge})>
      _verifiedSupplierDummies = [
    (
      name: 'Al-Rehman Agro Traders',
      city: 'Sahiwal',
      specialty: 'Wheat, maize, and grain lots',
      badge: 'Top rated',
    ),
    (
      name: 'Punjab Grain House',
      city: 'Multan',
      specialty: 'Bulk cereal sourcing',
      badge: 'Fast dispatch',
    ),
    (
      name: 'Pak Pulse Network',
      city: 'Lahore',
      specialty: 'Legumes and pulses',
      badge: 'Verified',
    ),
    (
      name: 'Bismillah Feed Mills',
      city: 'Faisalabad',
      specialty: 'Feed ingredients',
      badge: 'Trusted',
    ),
    (
      name: 'Green Yield Commodities',
      city: 'Gujranwala',
      specialty: 'Premium contracts',
      badge: 'Premium',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return AppContainer(
      backgroundColor: AppColors.backgroundPage,
      padding: const EdgeInsets.fromLTRB(
        AppSize.space32,
        0,
        AppSize.space32,
        AppSize.space16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Row(
            children: [
              AppText(
                text: 'Verified Suppliers',
                fontSize: AppSize.font20,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ],
          ),
          const SizedBox(height: AppSize.space16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (var i = 0; i < _verifiedSupplierDummies.length; i++) ...[
                  if (i > 0) const SizedBox(width: AppSize.space12),
                  _VerifiedSupplierProductCard(
                    supplierName: _verifiedSupplierDummies[i].name,
                    city: _verifiedSupplierDummies[i].city,
                    specialty: _verifiedSupplierDummies[i].specialty,
                    badge: _verifiedSupplierDummies[i].badge,
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: AppSize.space16),
          const _LogisticsAssuranceCard(),
        ],
      ),
    );
  }
}

class _VerifiedSupplierProductCard extends StatelessWidget {
  const _VerifiedSupplierProductCard({
    required this.supplierName,
    required this.city,
    required this.specialty,
    required this.badge,
  });

  final String supplierName;
  final String city;
  final String specialty;
  final String badge;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 210,
      child: AppContainer(
        padding: const EdgeInsets.all(AppSize.space12),
        backgroundColor: AppColors.backGroundWhite,
        borderRadius: BorderRadius.circular(AppSize.radius12),
        border: Border.all(color: AppColors.borderLight),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppContainer(
              height: 128,
              width: double.infinity,
              borderRadius: BorderRadius.circular(AppSize.radius12),
              backgroundColor: AppColors.backgroundSurface,
              alignment: Alignment.center,
              child: const Icon(
                Icons.person_rounded,
                size: 72,
                color: AppColors.iconSecondary,
              ),
            ),
            const SizedBox(height: AppSize.space8),
            AppText(
              text: supplierName,
              fontSize: AppSize.font14,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: AppSize.space2),
            AppText(
              text: '$city · Supplier',
              fontSize: AppSize.font12,
              fontWeight: FontWeight.w400,
              color: AppColors.textSecondary,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: AppSize.space4),
            AppText(
              text: specialty,
              fontSize: AppSize.font12,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: AppSize.space8),
            Align(
              alignment: Alignment.centerLeft,
              child: AppContainer(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSize.space8,
                  vertical: AppSize.space4,
                ),
                borderRadius: BorderRadius.circular(AppSize.radiusCircular),
                backgroundColor: AppColors.badgeSuccessBg,
                child: AppText(
                  text: badge,
                  fontSize: AppSize.font12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.badgeSuccessText,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LogisticsAssuranceCard extends StatelessWidget {
  const _LogisticsAssuranceCard();

  @override
  Widget build(BuildContext context) {
    return AppContainer(
      padding: const EdgeInsets.all(AppSize.space16),
      backgroundColor: AppColors.backGroundWhite,
      borderRadius: BorderRadius.circular(AppSize.radius12),
      border: Border.all(color: AppColors.borderLight),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AppContainer(
                width: 40,
                height: 40,
                borderRadius: BorderRadius.circular(AppSize.radius8),
                backgroundColor: AppColors.badgeInfoBg,
                alignment: Alignment.center,
                child: const Icon(
                  Icons.local_shipping_outlined,
                  color: AppColors.iconEmeraldGreen,
                  size: AppSize.icon20,
                ),
              ),
              const SizedBox(width: AppSize.space12),
              const Expanded(
                child: AppText(
                  text: 'Logistics & Payment Assurance',
                  fontSize: AppSize.font18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSize.space12),
          const AppText(
            text: 'Safer transactions with delivery visibility',
            fontSize: AppSize.font14,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppSize.space12),
          ...const [
            'Nationwide partner logistics coverage',
            'Escrow-ready settlement workflow',
            'Delivery and payment status tracking',
          ].map(
            (point) => Padding(
              padding: const EdgeInsets.only(bottom: AppSize.space8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: AppSize.space4),
                    child: Icon(
                      Icons.circle,
                      size: AppSize.icon12,
                      color: AppColors.iconEmeraldGreen,
                    ),
                  ),
                  const SizedBox(width: AppSize.space8),
                  Expanded(
                    child: AppText(
                      text: point,
                      fontSize: AppSize.font14,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textSecondary,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

