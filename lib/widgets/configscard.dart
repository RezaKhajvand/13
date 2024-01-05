import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vpn/bloc/getconfig_bloc/get_config_bloc.dart';
import 'package:vpn/constants/constants.dart';
import 'package:vpn/pages/configs_page/configspage.dart';
import 'package:vpn/utils/navigator.dart';

class ConfigCard extends StatelessWidget {
  const ConfigCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GetConfigBloc, GetConfigState>(
      listener: (context, state) {
        if (state is ConfigError) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(state.error),
            backgroundColor: CustomColors.error,
          ));
        }
        if (state is ConfigLoaded && state.isGettingConfigs) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Configs Loaded'),
            backgroundColor: CustomColors.secendry,
          ));
        }
      },
      builder: (context, state) {
        if (state is ConfigLoaded) {
          var image = state.configlist
              .where((element) => element.isclicked)
              .toList()
              .first
              .image;
          var remark = state.configlist
              .where((element) => element.isclicked)
              .toList()
              .first
              .remark;
          return InkWell(
            borderRadius: BorderRadius.circular(12),
            splashColor: CustomColors.secendry,
            onTap: () => CustomNav.push(context, const ConfigsPage()),
            child: Container(
              padding: const EdgeInsets.all(16),
              height: 80,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: CustomColors.glasscardfill,
                  borderRadius: BorderRadius.circular(12),
                  border:
                      Border.all(width: .5, color: CustomColors.cardborder)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        height: 40,
                        width: 40,
                        child: Image.asset(image),
                      ),
                      const SizedBox(width: 20),
                      Container(
                        width: 1,
                        height: double.infinity,
                        color: CustomColors.buttonhint,
                      ),
                      const SizedBox(width: 20),
                      SizedBox(
                        width: 140,
                        child: Text(
                          remark,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 26,
                    width: 26,
                    child: CircleAvatar(
                      backgroundColor: CustomColors.secendry,
                      child: Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: Colors.black,
                        size: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return InkWell(
          borderRadius: BorderRadius.circular(12),
          splashColor: CustomColors.secendry,
          onTap: () => CustomNav.push(context, const ConfigsPage()),
          child: Container(
            padding: const EdgeInsets.all(16),
            height: 80,
            width: double.infinity,
            decoration: BoxDecoration(
                color: CustomColors.glasscardfill,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(width: .5, color: CustomColors.cardborder)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const SizedBox(
                        height: 40,
                        width: 40,
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2),
                        )),
                    const SizedBox(width: 20),
                    Container(
                      width: 1,
                      height: double.infinity,
                      color: CustomColors.buttonhint,
                    ),
                    const SizedBox(width: 20),
                    const SizedBox(
                      width: 140,
                      child: Text(
                        'Loading Configs',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 26,
                  width: 26,
                  child: CircleAvatar(
                    backgroundColor: CustomColors.secendry,
                    child: Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Colors.black,
                      size: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
