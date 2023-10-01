import 'package:flutter/material.dart';
import 'package:selfcheckoutapp/screens/home.dart';
import 'package:selfcheckoutapp/services/khalti_payment_services.dart';
import 'package:selfcheckoutapp/widgets/custom_button.dart';

class PayViaKhalti extends StatefulWidget {
  final double? total;

  const PayViaKhalti({Key? key, this.total}) : super(key: key);

  @override
  State<PayViaKhalti> createState() => _PayViaKhaltiState();
}

class _PayViaKhaltiState extends State<PayViaKhalti> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 1,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepPurple,
          title: Image.asset("assets/khalti_logo.png"),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Wallet Payment'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            WalletPayment(total: widget.total!),
          ],
        ),
      ),
    );
  }
}

class WalletPayment extends StatefulWidget {
  final double total;

  const WalletPayment({Key? key, required this.total}) : super(key: key);

  @override
  State<WalletPayment> createState() => _WalletPaymentState();
}

class _WalletPaymentState extends State<WalletPayment> {
  TextEditingController? _mobileController, _pinController;
  final GlobalKey<FormState> _formKey = GlobalKey();
  bool _isLoading = false;
  bool _isLoadingConfirm = false;

  @override
  void initState() {
    super.initState();
    _mobileController = TextEditingController();
    _pinController = TextEditingController();
  }

  @override
  void dispose() {
    _mobileController!.dispose();
    _pinController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextFormField(
            validator: (v) => (v?.isEmpty ?? true) ? 'Required ' : null,
            decoration: InputDecoration(
              labelText: 'Mobile Number',
            ),
            controller: _mobileController,
          ),
          TextFormField(
            validator: (v) => (v?.isEmpty ?? true) ? 'Required ' : null,
            decoration: const InputDecoration(
              labelText: 'Khalti MPIN',
            ),
            controller: _pinController,
          ),
          const SizedBox(height: 24),
          CustomBtn(
            // ElevatedButton(
            onPressed: () async {
              if (!(_formKey.currentState?.validate() ?? false)) return;
              setState(() {
                _isLoading = true;
              });
              var token = await KhaltiServices.createPaymentIntent(
                  // '${widget.total.toStringAsFixed(0)}00',    enable after test
                  "1000",
                  _mobileController!.text,
                  _pinController!.text);

              if (token.isNotEmpty) {
                final otpCode = await showDialog<String>(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) {
                    String? _otp;
                    return AlertDialog(
                      title: const Text('OTP Sent!'),
                      content: TextField(
                        decoration: const InputDecoration(
                          labelText: 'OTP Code',
                        ),
                        onChanged: (v) => _otp = v,
                      ),
                      actions: [
                        CustomEditBtn(
                          isLoading: _isLoadingConfirm,
                          text: ('OK'),
                          onPressed: () async {
                            setState(() {
                              _isLoadingConfirm = true;
                            });
                            await KhaltiServices.payViaKhalti(
                                // amount: '${widget.total.toStringAsFixed(0)}00',    enable after test
                                confirmation_code: _otp!,
                                amount: "1000",
                                token: token,
                                transaction_pin: _pinController!.text);

                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text("Transaction Complete")));

                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomePage()));
                          },
                        )
                      ],
                    );
                  },
                );
              }
            },
            outlineBtn: true,
            isLoading: _isLoading,
            text: ('Pay Rs. ${widget.total.toString()}'),
          ),
        ],
      ),
    );
  }
}
